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
      ssh.deployKey = ./deploy.pub;
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
    };
  };
}
