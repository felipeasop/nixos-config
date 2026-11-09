{ den, ... }:
let
  system = "x86_64-linux";
  hostName = "aspire";
  userName = "flp";
in
{
  den = {
    hosts.${system}.${hostName} = {
      kernel = "latest";
      users.${userName}.classes = [ "homeManager" ];
    };

    aspects.${hostName} = {
      includes = with den.aspects; [
        den.batteries.hostname
        systemd-boot
        laptop

        # DEs / WMs
        lxqt
        niri-stack
        firefox
        intel-graphics

        { nixos = import ./_hardware.nix; }
      ];

      nixos = {
        hardware.enableRedistributableFirmware = true;

        swapDevices = [
          {
            device = "/swapfile";
            size = 4096;
          }
        ];
      };
    };
  };
}
