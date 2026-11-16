# https://docs.noctalia.dev/umbriel/workspaces-overview/
{
  den.aspects.umbriel = {
    homeManager = {
      programs.umbriel.settings = {
        overview = {
          zoom = 0.5;
          scroll_factor_horizontal = 1.0;
          scroll_factor_vertical = 1.0;
          background_blur = true;
          workspace_wallpaper = true;
          shortcuts = true;
          shortcut_keys = "1234567890";
        };

        # O niri abre o overview no canto superior esquerdo por padrão.
        hot_corners = {
          top_left = {
            enabled = true;
            delay_ms = 500;
            action = "overview-open";
          };
          top_right.enabled = false;
          bottom_left.enabled = false;
          bottom_right.enabled = false;
        };
      };
    };
  };
}
