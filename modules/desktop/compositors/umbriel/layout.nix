# https://docs.noctalia.dev/umbriel/layout/
# O niri só tem o scrolling; dwindle, master e stacking são extras do Umbriel,
# escolhidos por workspace (workspaces.nix) ou com `workspace-set-layout`.
{
  den.aspects.umbriel = {
    homeManager = {
      programs.umbriel.settings.layout = {
        mode = "scrolling"; # "scrolling", "dwindle", "master" ou "stacking"
        gap = 6;
        extent_presets = [
          0.33333
          0.5
          0.66667
        ];
        new_exits_fullscreen = [ ]; # "tiled", "floating", "pinned" ou "all"
        client_maximize = "column"; # "column" ou "edges"

        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };

        scrolling = {
          default_extent_fraction = 0.5;
          center_underfull_strip = true;
          center_focused = "never";
          center_on_overview_select = false;
        };

        dwindle = {
          preserve_split = false;
          new_toward_cursor = false;
        };

        master = {
          position = "left";
          default_width_fraction = 0.55;
          new_on_top = true;
          new_becomes_master = false;
        };

        stacking.drop_zones = true;

        # Abas por coluna, como as colunas em abas do niri.
        tabs = {
          default_display = "normal";
          new_tab_position = "end";
          wrap_focus = true;
          scroll_switches_tabs = true;
          middle_click_closes = false;
        };
      };
    };
  };
}
