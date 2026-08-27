# Aspect niri — Window / Layer Rules (rules.kdl).
{
  den.aspects.niri = {
    homeManager = {
      programs.niri.settings = {
        window-rules = [
          {
            open-maximized = false;
            open-fullscreen = false;

            geometry-corner-radius = {
              top-left = 8.0;
              top-right = 8.0;
              bottom-left = 8.0;
              bottom-right = 8.0;
            };
            clip-to-geometry = true;
          }

          {
            matches = [ { app-id = "steam"; } ];
            excludes = [ { title = "^[Ss]team$"; } ];
            open-floating = true;
          }

          {
            matches = [
              {
                app-id = "steam";
                title = "^notificationtoasts_\\d+_desktop$";
              }
            ];
            default-floating-position = {
              x = 10;
              y = 10;
              relative-to = "bottom-right";
            };
            open-focused = false;
          }
        ];

        layer-rules = [
          {
            matches = [ { namespace = "^noctalia-wallpaper"; } ];
            place-within-backdrop = true;
          }
        ];
      };
    };
  };
}
