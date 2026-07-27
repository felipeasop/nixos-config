{
  den.aspects.niri = {
    homeManager = {
      programs.niri.settings.input = {
        keyboard = {
          xkb.layout = "br";
          numlock = false; # `/- numlock` = desativado
        };

        touchpad = {
          click-method = "clickfinger";
          tap = true;
        };

        mouse = {
          accel-profile = "flat";
          accel-speed = 0.0;
        };

        focus-follows-mouse.enable = false;
        warp-mouse-to-focus.enable = false;

        workspace-auto-back-and-forth = true;
      };
    };
  };
}
