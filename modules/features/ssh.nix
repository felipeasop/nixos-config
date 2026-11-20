# Host com `ssh.hostKey` recebe SSH
# Host com `ssh.deployKey` faz deploy como root
#
# nh os switch ~/nixos-config -H <host> --target-host root@<host>.local
{ den, lib, ... }:
let
  allHosts = lib.concatMap lib.attrValues (lib.attrValues den.hosts);

  keyOption =
    description:
    lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      inherit description;
    };
in
{
  den = {
    schema.host.options.ssh = {
      hostKey = keyOption "Chave pública do host (/etc/ssh/ssh_host_ed25519_key.pub); liga o servidor SSH.";
      deployKey = keyOption "Chave pública do usuário que faz deploy; autorizada como root nos servidores.";
    };

    aspects.ssh =
      { host, ... }:
      let
        others = lib.filter (h: h.name != host.name) allHosts;
        servers = lib.filter (h: h.ssh.hostKey != null) others;
        clients = lib.filter (h: h.ssh.deployKey != null) others;

        server = {
          nixos = {
            services = {
              openssh = {
                enable = true;
                # Só as chaves declaradas no Nix valem
                authorizedKeysInHomedir = false;
                settings = {
                  PasswordAuthentication = false;
                  PermitRootLogin = "prohibit-password";
                  KbdInteractiveAuthentication = false;
                };
              };

              fail2ban = {
                enable = true;
                maxretry = 5;
                bantime = "1h";
              };
            };

            users.users.root.openssh.authorizedKeys.keyFiles = map (h: h.ssh.deployKey) clients;
          };
        };

        client = {
          nixos = {
            programs.ssh.knownHosts = lib.listToAttrs (
              map (
                h:
                lib.nameValuePair h.name {
                  hostNames = [ "${h.hostName}.local" ];
                  publicKeyFile = h.ssh.hostKey;
                }
              ) servers
            );
          };
        };
      in
      {
        includes =
          lib.optional (host.ssh.hostKey != null) server ++ lib.optional (host.ssh.deployKey != null) client;
      };
  };
}
