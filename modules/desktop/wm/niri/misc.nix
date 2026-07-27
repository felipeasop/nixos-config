{ inputs, ... }: {
  den.aspects.niri = {
    description = ''
      Niri: compositor Wayland em tiling scrollável (https://github.com/YaLTeR/niri)

      Configurado via https://github.com/sodiboo/niri-flake.
    '';

    homeManager = { ... }: {
      programs.niri.settings = {
        prefer-no-csd = true;
        screenshot-path = null;

        environment = {
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          QT_QPA_PLATFORM = "wayland";
          QT_QPA_PLATFORMTHEME = "kde";
          XDG_MENU_PREFIX = "plasma-";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          XDG_CURRENT_DESKTOP = "niri";
          XDG_SESSION_TYPE = "wayland";
        };

        cursor = {
          theme = "breeze_cursors";
          size = 24;
        };

        hotkey-overlay.skip-at-startup = true;
      };
    };
  };
}
