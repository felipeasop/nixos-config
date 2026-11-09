{
  den.aspects.niri = {
    homeManager = {
      programs.niri.settings.environment = {
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "kde";
        XDG_MENU_PREFIX = "plasma-";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";
      };
    };
  };
}
