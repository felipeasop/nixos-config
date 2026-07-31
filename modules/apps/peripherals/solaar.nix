{
  den.aspects.solaar = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.solaar ];
    };

    nixos = {
      hardware.logitech.wireless = {
        enable = true;
        enableGraphical = true; # isso habilita o systemd user service do tray/applet
      };
    };
  };
}
