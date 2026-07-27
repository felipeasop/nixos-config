{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings = {
        audio = {
          enable_overdrive = false;
          enable_sounds = false;
        };

        brightness = {
          enable_ddcutil = false;
          sync_all_monitors = false;
          minimum_brightness = 0.0;
          # ignore_mmids = [ ];  # IDs de monitores a ignorar
        };

        location = {
          auto_locate = true;
          # address = "São Paulo, BR";
          # custom_schedule = false;
          # sunrise = "";
          # sunset = "";
        };
      };
    };
  };
}
