{
  den.aspects.kitty = {
    homeManager = {
      programs.kitty = {
        enable = true;
        settings = {
          background_blur = 1;
          mouse_hide_wait = -1;
        };
      };

      xdg.terminal-exec = {
        enable = true;
        settings.default = [ "kitty.desktop" ];
      };
    };
  };
}
