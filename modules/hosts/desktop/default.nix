{ den, ... }:
let
  system = "x86_64-linux";
  hostName = "desktop";
  userName = "flp";
in
{
  den = {
    hosts.${system}.${hostName} = {
      kernel = "cachy";
      users.${userName}.classes = [ "homeManager" ];
    };

    aspects.${hostName} = {
      includes = with den.aspects; [
        den.batteries.hostname
        grub
        amd-graphics

        solaar-m650l

        kde
        niri-stack
        desktop-apps

        { nixos = import ./_hardware.nix; }
      ];

      # Chave do host aspire fixada para o deploy (root@aspire.local, via avahi).
      nixos = {
        programs.ssh.knownHosts.aspire = {
          hostNames = [ "aspire.local" ];
          publicKeyFile = ../aspire/ssh_host_ed25519_key.pub;
        };
      };
    };
  };
}
