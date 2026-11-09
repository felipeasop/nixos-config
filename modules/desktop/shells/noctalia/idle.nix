{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings = {
        idle = {
          behavior_order = [
            "lock"
            "screen-off"
            "lock-and-suspend"
          ];
          pre_action_fade_seconds = 2.0;

          behavior = {
            lock = {
              enabled = false;
              action = "lock";
              command = "";
              resume_command = "";
              timeout = 600.0;
            };
            screen-off = {
              enabled = false;
              action = "screen_off";
              command = "";
              resume_command = "";
              timeout = 660.0;
            };
            lock-and-suspend = {
              enabled = false;
              action = "lock_and_suspend";
              command = "";
              resume_command = "";
              timeout = 900.0;
            };
          };
        };
      };
    };
  };
}
