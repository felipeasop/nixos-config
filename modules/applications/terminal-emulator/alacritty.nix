{
  den.aspects.alacritty = {
    homeManager = {
      programs.alacritty = {
        enable = true;
        settings = {
          window = {
            opacity = 0.92;
            blur = true;
            dynamic_padding = true;
          };
          font = {
            size = 14;
            normal.family = "JetBrainsMono Nerd Font";
          };
          mouse.hide_when_typing = true;
        };
      };
    };
  };
}
