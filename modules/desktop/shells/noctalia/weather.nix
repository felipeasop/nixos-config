{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings = {
        weather = {
          enabled = true;
          effects = true;
          refresh_minutes = 30;
          unit = "metric"; # metric | imperial
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
