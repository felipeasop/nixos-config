# https://docs.noctalia.dev/umbriel/configuration/#environment
# XDG_CURRENT_DESKTOP e XDG_SESSION_TYPE, que o niri define aqui, são do
# próprio Umbriel e não podem ser sobrescritos.
{
  den.aspects.umbriel = {
    homeManager = {
      programs.umbriel.settings.environment = {
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "kde";
        XDG_MENU_PREFIX = "plasma-";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      };
    };
  };
}
