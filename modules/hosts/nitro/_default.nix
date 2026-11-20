{ den, ... }:
let
  system = "x86_64-linux";
  hostName = "nitro";
  userName = "flp";
in
{
  den = {
    hosts.${system}.${hostName} = {
      bootloader = "systemd-boot";
      kernel = "cachy";
      browser = "zen-browser";
      gpus = [
        "intel"
        "nvidia"
      ];
      # Após `ssh-keygen -t ed25519` no nitro, copiar a pública para cá.
      # ssh.deployKey = ./deploy.pub;
      users.${userName} = { };
    };

    aspects.${hostName} = {
      includes = with den.aspects; [
        laptop

        kde
        niri-stack
        desktop-apps

        { nixos = import ./_hardware.nix; }
      ];

      nixos = {
        # A confirmar na máquina: `lspci -D | grep -iE 'vga|3d'` (0000:00:02.0 vira "PCI:0@0:2:0").
        hardware.nvidia.prime = {
          intelBusId = "PCI:0@0:2:0";
          nvidiaBusId = "PCI:1@0:0:0";
        };
      };
    };
  };
}
