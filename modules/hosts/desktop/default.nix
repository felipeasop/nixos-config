{ den, ... }:
let
  system = "x86_64-linux";
  hostName = "desktop";
  userName = "flp";
in
{
  den = {
    hosts.${system}.${hostName} = {
      bootloader = "grub";
      kernel = "cachy";
      browser = "zen-browser";
      gpus = [ "amd" ];
      users.${userName} = { };
    };

    aspects.${hostName} = {
      includes = with den.aspects; [
        solaar-m650l

        kde
        niri-stack
        umbriel-stack
        desktop-apps

        { nixos = import ./_hardware.nix; }
      ];

      # Chave do host aspire fixada para o deploy (aspire.local, via avahi):
      # nh os switch ~/nixos-config -H aspire --target-host root@aspire.local
      nixos = {
        programs.ssh.knownHosts.aspire = {
          hostNames = [ "aspire.local" ];
          publicKeyFile = ../aspire/ssh_host_ed25519_key.pub;
        };
      };
    };
  };
}
