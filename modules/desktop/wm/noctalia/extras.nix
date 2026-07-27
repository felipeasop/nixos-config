# Docs oficiais: https://docs.noctalia.dev/v5/
# (não há referência exaustiva de opções; os defaults abaixo foram
# extraídos com `noctalia config export full`)
{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings = {
        accessibility = {
          high_contrast = false;
          ui_scale = 1.0;
        };

        battery = {
          warning_threshold = 10; # % de bateria pra disparar aviso
        };

        # brightness -> ver services.nix

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

        hooks = {
          # cada uma dessas listas aceita comandos/scripts a rodar no evento
          battery_charging = [ ];
          battery_discharging = [ ];
          battery_percentage_changed = [ ];
          battery_plugged = [ ];
          bluetooth_disabled = [ ];
          bluetooth_enabled = [ ];
          colors_changed = [ ];
          logging_out = [ ];
          power_profile_changed = [ ];
          rebooting = [ ];
          session_locked = [ ];
          session_unlocked = [ ];
          shutting_down = [ ];
          started = [ ];
          theme_mode_changed = [ ];
          wallpaper_changed = [ ];
          wifi_disabled = [ ];
          wifi_enabled = [ ];
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

        idle = {
          behavior_order = [
            "lock"
            "screen-off"
            "lock-and-suspend"
          ];
          pre_action_fade_seconds = 2.0;

          behavior = {
            lock = {
              enabled = false;
              action = "lock";
              command = "";
              resume_command = "";
              timeout = 600.0;
            };
            screen-off = {
              enabled = false;
              action = "screen_off";
              command = "";
              resume_command = "";
              timeout = 660.0;
            };
            lock-and-suspend = {
              enabled = false;
              action = "lock_and_suspend";
              command = "";
              resume_command = "";
              timeout = 900.0;
            };
          };
        };

        keybinds = {
          # teclas usadas DENTRO das UIs do noctalia (launcher, etc),
          # não confundir com binds do niri (aqueles ficam em cfg/binds.kdl)
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

        # location -> ver services.nix

        nightlight = {
          enabled = false;
          force = false;
          temperature_day = 6500;
          temperature_night = 4000;
        };

        notification = {
          background_opacity = 0.97;
          border = true;
          collapse_on_dismiss = true;
          enable_daemon = true;
          layer = "top";
          monitors = [ ];
          offset_x = 20;
          offset_y = 8;
          position = "top_right";
          scale = 1.0;
          show_actions = true;
          show_app_name = true;
        };

        plugins = {
          auto_update = true;
          enabled = [ ]; # nomes de plugins ativos, ex: [ "zen-browser" ]
          source = [
            {
              name = "official";
              kind = "git";
              location = "https://github.com/noctalia-dev/official-plugins";
              enabled = true;
            }
            {
              name = "community";
              kind = "git";
              location = "https://github.com/noctalia-dev/community-plugins";
              enabled = true;
            }
          ];
        };

        weather = {
          enabled = true;
          effects = true;
          refresh_minutes = 30;
          unit = "metric"; # metric | imperial
        };

        system.monitor = {
          enabled = true;
          cpu_poll_seconds = 2.0;
          cpu_temp_sensor_path = "";
          cpu_temp_activity_threshold = 60.0;
          cpu_temp_critical_threshold = 85.0;
          cpu_usage_activity_threshold = 50.0;
          cpu_usage_critical_threshold = 90.0;
          disk_poll_seconds = 10.0;
          disk_pct_activity_threshold = 80.0;
          disk_pct_critical_threshold = 95.0;
          gpu_poll_seconds = 5.0;
          gpu_temp_activity_threshold = 60.0;
          gpu_temp_critical_threshold = 85.0;
          gpu_usage_activity_threshold = 50.0;
          gpu_usage_critical_threshold = 95.0;
          gpu_vram_activity_threshold = 50.0;
          gpu_vram_critical_threshold = 90.0;
          memory_poll_seconds = 2.0;
          ram_pct_activity_threshold = 60.0;
          ram_pct_critical_threshold = 90.0;
          swap_pct_activity_threshold = 20.0;
          swap_pct_critical_threshold = 80.0;
          network_poll_seconds = 3.0;
          net_rx_activity_threshold = 1.0;
          net_rx_critical_threshold = 50.0;
          net_tx_activity_threshold = 1.0;
          net_tx_critical_threshold = 50.0;
        };
      };
    };
  };
}
