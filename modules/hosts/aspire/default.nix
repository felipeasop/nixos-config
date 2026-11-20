{ den, ... }:
let
  system = "x86_64-linux";
  hostName = "aspire";
  userName = "flp";
in
{
  den = {
    hosts.${system}.${hostName} = {
      bootloader = "systemd-boot";
      kernel = "latest";
      browser = "firefox";
      gpus = [ "intel" ];
      ssh.hostKey = ./ssh_host_ed25519_key.pub;
      users.${userName} = { };
    };

    aspects.${hostName} = {
      includes = with den.aspects; [
        laptop

        # DEs / WMs
        lxqt
        niri-stack

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
