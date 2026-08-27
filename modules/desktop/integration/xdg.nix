{
  den.aspects.xdg = {
    nixos = { pkgs, ... }: {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          kdePackages.xdg-desktop-portal-kde
        ];

        config.common = {
          default = [
            "gtk"
            "kde"
          ];
          "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        };

        config."niri" = {
          default = [
            "gnome"
            "gtk"
            "kde"
          ];
          "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        };
      };

      environment.systemPackages = with pkgs; [
        kdePackages.kde-gtk-config
        nwg-look
      ];
    };
  };
}
