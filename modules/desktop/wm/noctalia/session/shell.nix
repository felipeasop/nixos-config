{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings.shell = {
        font_family = "sans-serif";
        time_format = "{:%H:%M}";
        date_format = "%A, %x";

        ui_scale = 1.0; # ou use accessibility.ui_scale abaixo
        corner_radius_scale = 1.0;

        clipboard_enabled = true;
        clipboard_history_max_entries = 100;
        clipboard_auto_paste = "auto";
        clipboard_confirm_clear_history = true;

        launch_apps_as_systemd_services = true; # recomendado com systemd.enable abaixo
        # launch_apps_custom_command = "";

        app_icon_colorize = false;
        button_borders = true;
        input_borders = true;
        popup_borders = true;
        popup_shadows = true;

        middle_click_opens_widget_settings = true;
        niri_overview_type_to_launch_enabled = true;

        offline_mode = false;
        telemetry_enabled = false;
        setup_wizard_enabled = false; # já configurado via Nix, não precisa do wizard

        animation = {
          enabled = true;
          speed = 1.0;
        };

        shadow = {
          direction = "down";
          alpha = 0.55;
        };

        launcher = {
          show_icons = true;
          compact = false;
          categories = true;
          app_grid = false;
          sort_by_usage = true;
          provider_prefix = "/";
          fetch_exchange_rates = true;
        };

        panel = {
          launcher_placement = "floating";
          launcher_position = "center";
          control_center_placement = "attached";
          control_center_position = "auto";
          session_placement = "attached";
          session_position = "auto";
          clipboard_placement = "floating";
          clipboard_position = "center";
          polkit_placement = "floating";
          polkit_position = "center";
          transparency_mode = "solid";
          floating_offset = 8;
          borders = true;
          shadow = true;
        };

        screenshot = {
          copy_to_clipboard = true;
          save_to_file = true;
          freeze_screen = true;
          confirm_region = false;
          # directory = "/home/flp/Pictures/screenshots";
          # pipe_to_command = true;
          # pipe_command = "satty -f -";
        };

        session = {
          grid = false;
          grid_columns = 3;
          actions = [
            {
              action = "lock";
              shortcut = "1";
              enabled = true;
              variant = "default";
            }
            {
              action = "logout";
              shortcut = "2";
              enabled = true;
              variant = "default";
            }
            {
              action = "lock_and_suspend";
              shortcut = "3";
              enabled = true;
              variant = "default";
            }
            {
              action = "reboot";
              shortcut = "4";
              enabled = true;
              variant = "default";
            }
            {
              action = "shutdown";
              shortcut = "5";
              enabled = true;
              variant = "destructive";
            }
          ];
        };
      };
    };
  };
}
