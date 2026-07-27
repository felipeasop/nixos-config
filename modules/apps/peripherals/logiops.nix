{
  den.aspects.logiops = {
    nixos = {
      services.logiops = {
        enable = true;
        config = {
          devices = [
            {
              name = "M650";
              smartshift = {
                on = true;
                threshold = 30;
              };
              hiresscroll = {
                hires = false;
                invert = false;
                target = false;
              };
              buttons = [
                {
                  cid = 83; # 0x53
                  action = {
                    type = "Keypress";
                    keys = [ "KEY_BACK" ];
                  };
                }
                {
                  cid = 86; # 0x56
                  action = {
                    type = "Keypress";
                    keys = [ "KEY_FORWARD" ];
                  };
                }
              ];
            }
          ];
        };
      };
    };
  };
}
