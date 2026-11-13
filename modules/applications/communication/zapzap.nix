{
  den.aspects.zapzap = {
    homeManager = { config, ... }: {
      programs.zapzap = {
        enable = true;

        settings = {
          # Sem isso o menu de config aparece sempre que abrir
          onboarding.initial_setup_completed = true;

          system = {
            scale = 100;
            theme = if config.stylix.polarity == "either" then "auto" else config.stylix.polarity;
            wayland = true;
          };

          website.open_page = false;
        };
      };
    };
  };
}
