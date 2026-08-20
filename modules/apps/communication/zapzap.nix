{
  den.aspects.zapzap = {
    homeManager = {
      programs.zapzap = {
        enable = true;

        settings = {
          system = {
            scale = 100;
            theme = "dark";
            wayland = true;
          };

          website.open_page = false;
        };
      };
    };
  };
}
