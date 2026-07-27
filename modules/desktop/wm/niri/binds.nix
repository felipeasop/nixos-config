{
  den.aspects.niri = {
    homeManager = {
      programs.niri.settings.binds = {
        "Mod+Shift+Escape".action.show-hotkey-overlay = { };

        "Mod+Return" = {
          hotkey-overlay.title = "Open Terminal";
          action.spawn = [ "ghostty" ];
        };
        "Mod+D" = {
          hotkey-overlay.title = "Open App Launcher";
          action.spawn-sh = "noctalia msg panel-toggle launcher";
        };
        "Mod+B" = {
          hotkey-overlay.title = "Open Browser";
          action.spawn-sh = "zen-browser || zen-beta || zen-twilight";
        };
        "Mod+Shift+B" = {
          hotkey-overlay.title = "Open Browser (Private)";
          action.spawn-sh = "librewolf -private-window || zen-browser -private-window || zen-beta -private-window || zen-twilight -private-window";
        };
        "Mod+Alt+L" = {
          hotkey-overlay.title = "Lock Screen";
          action.spawn-sh = "noctalia msg session lock";
        };
        "Mod+Shift+Q" = {
          hotkey-overlay.title = "Session Menu";
          action.spawn-sh = "noctalia msg session menu";
        };
        "Mod+E" = {
          hotkey-overlay.title = "File Manager";
          action.spawn = [ "dolphin" ];
        };
        "Mod+Shift+E" = {
          hotkey-overlay.title = "File Manager";
          action.spawn = [
            "ghostty"
            "-e"
            "yazi"
          ];
        };
        "Mod+A" = {
          hotkey-overlay.title = "Open Spotify";
          action.spawn-sh = "spotify";
        };
        "Mod+Shift+S" = {
          hotkey-overlay.title = "Open Steam";
          action.spawn-sh = "steam";
        };
        "Mod+Z" = {
          hotkey-overlay.title = "Open Zed Editor";
          action.spawn-sh = "zeditor";
        };
        "Mod+X" = {
          hotkey-overlay.title = "Open System Monitor";
          action.spawn = [
            "ghostty"
            "-e"
            "btop"
          ];
        };

        "Mod+S" = {
          hotkey-overlay.title = "Noctalia Control Center";
          action.spawn-sh = "noctalia msg panel-toggle control-center";
        };
        "Mod+Comma" = {
          hotkey-overlay.title = "Noctalia Settings";
          action.spawn-sh = "noctalia msg settings-toggle";
        };
        "Alt+Tab" = {
          hotkey-overlay.title = "Noctalia Window Switcher";
          action.spawn-sh = "noctalia msg window-switcher";
        };

        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn-sh = "noctalia msg volume-up";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn-sh = "noctalia msg volume-down";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn-sh = "noctalia msg volume-mute";
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          action.spawn-sh = "noctalia msg media-next";
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          action.spawn-sh = "noctalia msg media-previous";
        };
        "XF86AudioPlay" = {
          allow-when-locked = true;
          action.spawn-sh = "noctalia msg media-play-pause";
        };
        "XF86AudioPause" = {
          allow-when-locked = true;
          action.spawn-sh = "noctalia msg media-play-pause";
        };

        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn-sh = "noctalia msg brightness-up";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn-sh = "noctalia msg brightness-down";
        };

        "Mod+Q".action.close-window = { };

        "Mod+H".action.focus-column-left = { };
        "Mod+J".action.focus-window-or-workspace-down = { };
        "Mod+K".action.focus-window-or-workspace-up = { };
        "Mod+L".action.focus-column-right = { };

        "Mod+Left".action.focus-column-left = { };
        "Mod+Down".action.focus-window-or-workspace-down = { };
        "Mod+Up".action.focus-window-or-workspace-up = { };
        "Mod+Right".action.focus-column-right = { };

        "Mod+BracketLeft".action.consume-window-into-column = { };
        "Mod+BracketRight".action.expel-window-from-column = { };

        "Mod+Ctrl+H".action.move-column-left = { };
        "Mod+Ctrl+J".action.move-window-to-workspace-down = { };
        "Mod+Ctrl+K".action.move-window-to-workspace-up = { };
        "Mod+Ctrl+L".action.move-column-right = { };

        "Mod+Ctrl+Left".action.move-column-left = { };
        "Mod+Ctrl+Down".action.move-window-to-workspace-down = { };
        "Mod+Ctrl+Up".action.move-window-to-workspace-up = { };
        "Mod+Ctrl+Right".action.move-column-right = { };

        "Mod+Home".action.focus-column-first = { };
        "Mod+End".action.focus-column-last = { };
        "Mod+Ctrl+Home".action.move-column-to-first = { };
        "Mod+Ctrl+End".action.move-column-to-last = { };

        "Mod+Shift+Left".action.focus-monitor-left = { };
        "Mod+Shift+Right".action.focus-monitor-right = { };
        "Mod+Shift+Up".action.focus-monitor-up = { };
        "Mod+Shift+Down".action.focus-monitor-down = { };

        "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = { };
        "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = { };
        "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = { };
        "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = { };

        "Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-workspace-down = { };
        };
        "Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-workspace-up = { };
        };
        "Mod+Ctrl+WheelScrollDown" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-down = { };
        };
        "Mod+Ctrl+WheelScrollUp" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-up = { };
        };

        "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
        "Mod+Shift+WheelScrollUp".action.focus-column-left = { };
        "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = { };
        "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = { };

        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;

        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        "Mod+R".action.switch-preset-column-width = { };
        "Mod+F".action.maximize-column = { };
        "Mod+C".action.center-column = { };
        "Mod+Shift+C".action.center-visible-columns = { };
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        "Mod+Shift+1".action.set-column-width = "33.333%";
        "Mod+Shift+2".action.set-column-width = "50%";
        "Mod+Shift+3".action.set-column-width = "66.667%";

        "Mod+T".action.toggle-window-floating = { };
        "Mod+Shift+F".action.fullscreen-window = { };

        "Print".action.screenshot = { };
        "Alt+Print".action.screenshot-window = { };
        "Ctrl+Print".action.screenshot-screen = { };

        "Mod+Escape" = {
          allow-inhibiting = false;
          action.toggle-keyboard-shortcuts-inhibit = { };
        };

        "Ctrl+Alt+Delete".action.quit = { };
        "Mod+O" = {
          repeat = false;
          action.toggle-overview = { };
        };
        "Mod+W" = {
          repeat = false;
          action.toggle-overview = { };
        };
      };
    };
  };
}
