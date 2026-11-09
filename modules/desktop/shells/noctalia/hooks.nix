{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings = {
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
      };
    };
  };
}
