{
  den.aspects.ghostty = {
    homeManager = {
      programs.ghostty = {
        enable = true;
        settings = {
          window-inherit-font-size = false;
          window-theme = "ghostty";
          window-padding-balance = true;
          background-opacity = 0.92;
          background-blur = true;
          font-family = "JetBrainsMono Nerd Font";
          font-size = 14;
          mouse-hide-while-typing = true;
        };
      };

      home.sessionVariables = {
        GTK_IM_MODULE = "simple";
      };
    };
  };
}
