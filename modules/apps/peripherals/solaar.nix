{
  den.aspects.solaar = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.solaar ];
      hardware.logitech.wireless = {
        enable = true;
        enableGraphical = true; # isso habilita o systemd user service do tray/applet
      };
    };
  };
}
