{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings = {
        accessibility = {
          high_contrast = false;
          ui_scale = 1.0;
        };

        audio = {
          enable_overdrive = false;
          enable_sounds = false;
        };

        battery = {
          warning_threshold = 10; # % de bateria pra disparar aviso
        };

        calendar = {
          enabled = false;
          refresh_minutes = 15;
        };

        desktop_widgets = {
          enabled = true;
          schema_version = 2;
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
        };

        hot_corners = {
          enabled = false;
          delay_ms = 0;
          top_left = {
            action = "none";
            command = "";
          };
          top_right = {
            action = "none";
            command = "";
          };
          bottom_left = {
            action = "none";
            command = "";
          };
          bottom_right = {
            action = "none";
            command = "";
          };
          # action: none | show-overview | show-launcher | show-control-center | lock | custom
        };

        keybinds = {
          # teclas usadas DENTRO das UIs do noctalia (launcher, etc),
          # não confundir com os binds do niri (compositors/niri/binds.nix)
          cancel = [ "Escape" ];
          down = [ "Down" ];
          left = [ "Left" ];
          right = [ "Right" ];
          tab_next = [ "Tab" ];
          tab_previous = [ "Shift+ISO_Left_Tab" ];
          up = [ "Up" ];
          validate = [
            "Return"
            "KP_Enter"
            "space"
          ];
        };

        nightlight = {
          enabled = false;
          force = false;
          temperature_day = 6500;
          temperature_night = 4000;
        };
      };
    };
  };
}
