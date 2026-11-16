{ den, ... }:
let
  system = "x86_64-linux";
  hostName = "template";
  userName = "flp";
in
{
  den = {
    hosts.${system}.${hostName} = {
      bootloader = "systemd-boot";
      kernel = "latest";
      browser = "firefox";
      gpus = [ "intel" ];
      users.${userName} = { };
    };

    aspects.${hostName} = {
      includes = with den.aspects; [
        kde

        { nixos = import ./_hardware.nix; }
      ];
    };
  };
}
