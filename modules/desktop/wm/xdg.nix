{
  den.aspects.xdg = {
    nixos = { pkgs, ... }: {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          kdePackages.xdg-desktop-portal-kde
        ];
        config.common.default = [
          "kde"
          "gtk"
        ];
      };

      environment.systemPackages = with pkgs; [
        kdePackages.kde-gtk-config
        nwg-look
      ];
    };
  };
}
