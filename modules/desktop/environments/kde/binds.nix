{
  den.aspects.kde = {
    provides.to-users = {
      homeManager = {
        programs.plasma = {
          shortcuts = {
            kwin = {
              "Switch to Desktop 1" = "Meta+1";
              "Switch to Desktop 2" = "Meta+2";
              "Switch to Desktop 3" = "Meta+3";
              "Switch to Desktop 4" = "Meta+4";
              "Window to Desktop 1" = "Meta+Ctrl+1";
              "Window to Desktop 2" = "Meta+Ctrl+2";
              "Window to Desktop 3" = "Meta+Ctrl+3";
              "Window to Desktop 4" = "Meta+Ctrl+4";
            };

            plasmashell = {
              "activate task manager entry 1" = "none";
              "activate task manager entry 2" = "none";
              "activate task manager entry 3" = "none";
              "activate task manager entry 4" = "none";
              "activate task manager entry 5" = "none";
              "activate task manager entry 6" = "none";
              "activate task manager entry 7" = "none";
              "activate task manager entry 8" = "none";
              "activate task manager entry 9" = "none";
              "activate task manager entry 10" = "none";
            };

            "services/plasma-manager-commands.desktop"."launch-terminal" = "Meta+Return";
          };

          hotkeys.commands."launch-terminal" = {
            name = "Launch Terminal";
            key = "Meta+Return";
            command = "xdg-terminal-exec";
          };
        };
      };
    };
  };
}
