{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings.widget = {
        date = {
          type = "clock";
          format = "{:%a %d %b}";
        };

        cpu = {
          type = "sysmon";
          stat = "cpu_usage";
        };

        temp = {
          type = "sysmon";
          stat = "cpu_temp";
        };

        ram = {
          type = "sysmon";
          stat = "ram_used";
        };

        network_rx = {
          type = "sysmon";
          stat = "net_rx";
        };

        network_tx = {
          type = "sysmon";
          stat = "net_tx";
        };

        output_volume = {
          type = "volume";
          device = "output";
        };

        input_volume = {
          type = "volume";
          device = "input";
        };

        media = {
          type = "media";
          min_length = 80.0;
          max_length = 220.0;
          art_size = 16.0;
          title_scroll = "none";
        };

        active_window = {
          type = "active_window";
          min_length = 80.0;
          max_length = 260.0;
          icon_size = 14.0;
          title_scroll = "none";
        };

        keyboard_layout = {
          type = "keyboard_layout";
          hide_when_single_layout = false;
          cycle_command = "";
        };

        lock_keys = {
          type = "lock_keys";
          display = "short";
          show_caps_lock = true;
          show_num_lock = true;
          show_scroll_lock = false;
          hide_when_off = false;
        };

        spacer = {
          type = "spacer";
        };

        # Todos os tipos disponíveis (usar como "type" em qualquer novo [widget.<nome>]):
        # clock, spacer, workspaces, taskbar, active_window, control-center, sysmon, volume,
        # audio_visualizer, media, privacy, battery, brightness, bluetooth, network,
        # keyboard_layout, lock_keys, launcher, custom_button, clipboard, screenshot, weather,
        # notifications, tray, power_profile, caffeine, nightlight, theme_mode, settings,
        # session, wallpaper. Plugin: type = "<author>/<plugin>:<entry>";
      };
    };
  };
}
