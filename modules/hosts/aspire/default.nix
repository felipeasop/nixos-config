{ den, ... }:
let
  system = "x86_64-linux";
  hostName = "aspire";
  userName = "flp";
in
{
  den.hosts.${system}.${hostName} = {
    kernel = "latest";
    users.${userName}.classes = [ "homeManager" ];
  };

  den.aspects.${hostName} = {
    includes = with den.aspects; [
      den.provides.hostname
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

    # host-aspects (flp.nix) só projeta o que está no includes escrito à mão;
    # essential chega via den.schema.host.includes, invisível pra battery.
    provides.to-users.includes = with den.aspects; [ essential ];
  };
}
