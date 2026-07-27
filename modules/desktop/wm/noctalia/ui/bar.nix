{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings.bar = {
        order = [ "default" ];

        default = {
          enabled = true;
          position = "top"; # top | bottom | left | right
          thickness = 34;
          background_opacity = 1.0;
          border = "outline";
          border_width = 0.0;
          radius = 12;
          # radius_top_left / radius_top_right / radius_bottom_left / radius_bottom_right = 12 individualmente se quiser assimetria
          concave_edge_corners = true;
          margin_edge = 0; # >0 deixa a barra "flutuante"
          margin_ends = 0;
          margin_opposite_edge = 0;
          padding = 14;
          widget_spacing = 6;
          scale = 1.0;
          font_weight = 500; # 100-1000
          auto_hide = false;
          smart_auto_hide = false;
          show_on_workspace_switch = true;
          layer = "top"; # top | overlay
          reserve_space = true;
          panel_overlap = 1;
          hover_highlight = true;
          shadow = true;
          contact_shadow = false;

          capsule = false;
          capsule_fill = "surface_variant";
          capsule_opacity = 1.0;
          capsule_padding = 6.0;
          capsule_thickness = 0.76;
          capsule_group = [ ];

          start = [
            "launcher"
            "wallpaper"
            "workspaces"
          ];
          center = [ "clock" ];
          end = [
            "media"
            "tray"
            "notifications"
            "clipboard"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
            "control-center"
            "session"
          ];

          dead_zone = {
            command = "";
            middle_command = "";
            right_command = ""; # "" = abre o Control Center por padrão
            scroll_up_command = "";
            scroll_down_command = "";
          };
        };
      };
    };
  };
}
