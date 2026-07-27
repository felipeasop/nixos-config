{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings.osd = {
        enabled = true;
        position = "top_center";
        position_vertical = "top_center";
        orientation = "horizontal";
        scale = 1.0;
        background_opacity = 0.97;
        border = true;
        offset_x = 20;
        offset_y = 8;
        monitors = [ ];

        kinds = {
          volume = true;
          volume_output = true;
          volume_input = true;
          brightness = true;
          media = true;
          nightlight = true;
          caffeine = true;
          power_profile = true;
          bluetooth = true;
          wifi = true;
          dnd = true;
          privacy = true;
          keyboard_layout = true;
          lock_keys = true;
          keyboard_backlight = true;
        };
      };
    };
  };
}
