{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings.control_center = {
        sidebar = "compact"; # full | compact | none
        width = 700;
        hidden_tabs = [ ];

        calendar.show_events_card = true;

        shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "caffeine"; }
          { type = "nightlight"; }
          { type = "notification"; }
          { type = "power_profile"; }
        ];
        # Outros tipos: dark_mode, audio, mic_mute, media, weather, system,
        # screen_time, keyboard_layout, wallpaper, session, clipboard.
      };
    };
  };
}
