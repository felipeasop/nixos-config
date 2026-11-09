{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings.dock = {
        enabled = false;
        position = "bottom"; # top | bottom | left | right
        pinned = [ ]; # ex: [ "firefox" "org.kde.dolphin" "steam" ]
        monitors = [ ]; # vazio = todos

        auto_hide = false;
        smart_auto_hide = false;
        active_monitor_only = false;

        launcher_position = "start"; # none | start | end
        launcher_icon = "grid-dots";

        magnification = true;
        magnification_scale = 1.45;

        show_running = true;
        show_dots = false;
        show_instance_count = true;

        icon_size = 48;
        item_spacing = 6;
        main_axis_padding = 16;
        cross_axis_padding = 8;
        margin_edge = 0;
        margin_ends = 0;

        background_opacity = 0.88;
        border = "outline";
        border_width = 0.0;
        radius = 16;
        concave_edge_corners = true;

        active_opacity = 1.0;
        active_scale = 1.0;
        inactive_opacity = 0.85;
        inactive_scale = 0.85;

        reserve_space = true;
        shadow = true;
      };
    };
  };
}
