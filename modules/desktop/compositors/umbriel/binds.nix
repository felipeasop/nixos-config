# https://docs.noctalia.dev/umbriel/keybinds/ e /umbriel/actions/
# Esta tabela substitui todos os atalhos padrão do Umbriel. `spawn` já roda pelo
# shell (equivale ao spawn-sh do niri). Diferenças em relação ao niri:
# - não há título por atalho (hotkey-overlay.title); o cheatsheet mostra a ação;
# - não há screenshot próprio: Print usa o do Noctalia;
# - não há center-visible-columns (Mod+Shift+C do niri);
# - consume/expel do niri viram window-consume-from-right e
#   window-consume-or-expel-right;
# - o script niri-move-window-to-new-workspace (Mod+Ctrl+Alt+*) não tem
#   equivalente: falta uma ação que mova o workspace para uma posição.
{
  den.aspects.umbriel = {
    homeManager = {
      programs.umbriel.settings.keybinds = {
        "Mod+Shift+Escape" = "cheatsheet-toggle";

        "Mod+Return" = "spawn xdg-terminal-exec";
        "Mod+Shift+Return" = "spawn foot";
        "Mod+D" = "spawn noctalia msg panel-toggle launcher";
        "Mod+B" = "spawn default-browser";
        "Mod+Shift+B" = "spawn default-browser --private";
        "Mod+Alt+L" = "spawn noctalia msg session lock";
        "Mod+Shift+Q" = "spawn noctalia msg session menu";
        "Mod+E" = "spawn xdg-terminal-exec yazi";
        "Mod+Shift+E" = "spawn dolphin";
        "Mod+A" = "spawn spotify";
        "Mod+Shift+S" = "spawn steam";
        "Mod+Z" = "spawn zeditor";
        "Mod+X" = "spawn xdg-terminal-exec btop";

        "Mod+S" = "spawn noctalia msg panel-toggle control-center";
        "Mod+Comma" = "spawn noctalia msg settings-toggle";
        "Alt+Tab" = "spawn noctalia msg window-switcher";

        # Comandos de mídia conforme a doc atual do Noctalia (`media toggle|next|previous`).
        "XF86AudioRaiseVolume" = {
          action = "spawn noctalia msg volume-up";
          allow_when_locked = true;
        };
        "XF86AudioLowerVolume" = {
          action = "spawn noctalia msg volume-down";
          allow_when_locked = true;
        };
        "XF86AudioMute" = {
          action = "spawn noctalia msg volume-mute";
          allow_when_locked = true;
        };
        "XF86AudioNext" = {
          action = "spawn noctalia msg media next";
          allow_when_locked = true;
        };
        "XF86AudioPrev" = {
          action = "spawn noctalia msg media previous";
          allow_when_locked = true;
        };
        "XF86AudioPlay" = {
          action = "spawn noctalia msg media toggle";
          allow_when_locked = true;
        };
        "XF86AudioPause" = {
          action = "spawn noctalia msg media toggle";
          allow_when_locked = true;
        };

        "XF86MonBrightnessUp" = {
          action = "spawn noctalia msg brightness-up";
          allow_when_locked = true;
        };
        "XF86MonBrightnessDown" = {
          action = "spawn noctalia msg brightness-down";
          allow_when_locked = true;
        };

        "Mod+Q" = "window-close";

        "Mod+H" = "window-focus-left";
        "Mod+J" = "window-focus-or-workspace-down";
        "Mod+K" = "window-focus-or-workspace-up";
        "Mod+L" = "window-focus-right";

        "Mod+Left" = "window-focus-left";
        "Mod+Down" = "window-focus-or-workspace-down";
        "Mod+Up" = "window-focus-or-workspace-up";
        "Mod+Right" = "window-focus-right";

        "Mod+BracketLeft" = "window-consume-from-right";
        "Mod+BracketRight" = "window-consume-or-expel-right";

        "Mod+Ctrl+H" = "column-move-left";
        "Mod+Ctrl+J" = "window-move-to-workspace-next";
        "Mod+Ctrl+K" = "window-move-to-workspace-previous";
        "Mod+Ctrl+L" = "column-move-right";

        "Mod+Ctrl+Left" = "column-move-left";
        "Mod+Ctrl+Down" = "window-move-to-workspace-next";
        "Mod+Ctrl+Up" = "window-move-to-workspace-previous";
        "Mod+Ctrl+Right" = "column-move-right";

        "Mod+Home" = "column-focus-first";
        "Mod+End" = "column-focus-last";
        "Mod+Ctrl+Home" = "column-move-to-first";
        "Mod+Ctrl+End" = "column-move-to-last";

        "Mod+Shift+Left" = "output-focus-left";
        "Mod+Shift+Right" = "output-focus-right";
        "Mod+Shift+Up" = "output-focus-up";
        "Mod+Shift+Down" = "output-focus-down";

        "Mod+Shift+Ctrl+Left" = "column-move-to-output-left";
        "Mod+Shift+Ctrl+Right" = "column-move-to-output-right";
        "Mod+Shift+Ctrl+Up" = "column-move-to-output-up";
        "Mod+Shift+Ctrl+Down" = "column-move-to-output-down";

        "Mod+WheelDown" = {
          action = "workspace-next";
          cooldown_ms = 150;
        };
        "Mod+WheelUp" = {
          action = "workspace-previous";
          cooldown_ms = 150;
        };
        "Mod+Ctrl+WheelDown" = {
          action = "column-move-to-workspace-next";
          cooldown_ms = 150;
        };
        "Mod+Ctrl+WheelUp" = {
          action = "column-move-to-workspace-previous";
          cooldown_ms = 150;
        };

        "Mod+Shift+WheelDown" = "window-focus-right";
        "Mod+Shift+WheelUp" = "window-focus-left";
        "Mod+Ctrl+Shift+WheelDown" = "column-move-right";
        "Mod+Ctrl+Shift+WheelUp" = "column-move-left";

        "Mod+1" = "workspace-switch 1";
        "Mod+2" = "workspace-switch 2";
        "Mod+3" = "workspace-switch 3";
        "Mod+4" = "workspace-switch 4";
        "Mod+5" = "workspace-switch 5";
        "Mod+6" = "workspace-switch 6";
        "Mod+7" = "workspace-switch 7";
        "Mod+8" = "workspace-switch 8";
        "Mod+9" = "workspace-switch 9";

        "Mod+Ctrl+1" = "column-move-to-workspace 1";
        "Mod+Ctrl+2" = "column-move-to-workspace 2";
        "Mod+Ctrl+3" = "column-move-to-workspace 3";
        "Mod+Ctrl+4" = "column-move-to-workspace 4";
        "Mod+Ctrl+5" = "column-move-to-workspace 5";
        "Mod+Ctrl+6" = "column-move-to-workspace 6";
        "Mod+Ctrl+7" = "column-move-to-workspace 7";
        "Mod+Ctrl+8" = "column-move-to-workspace 8";
        "Mod+Ctrl+9" = "column-move-to-workspace 9";

        "Mod+R" = "window-cycle-primary-extent";
        "Mod+F" = "window-toggle-maximize";
        "Mod+C" = "column-center";
        "Mod+Minus" = "window-modify-primary-extent -0.1";
        "Mod+Equal" = "window-modify-primary-extent +0.1";
        "Mod+Shift+Minus" = "window-modify-secondary-extent -0.1";
        "Mod+Shift+Equal" = "window-modify-secondary-extent +0.1";

        "Mod+T" = "window-toggle-floating";
        "Mod+Shift+F" = "window-toggle-fullscreen";

        "Print" = "spawn noctalia msg screenshot-region";
        "Alt+Print" = "spawn noctalia msg screenshot-window";
        "Ctrl+Print" = "spawn noctalia msg screenshot-fullscreen";

        "Mod+Escape" = {
          action = "shortcuts-inhibit-toggle";
          allow_when_inhibited = true;
          repeat = false;
        };

        "Ctrl+Alt+Delete" = "session-quit";
        "Mod+O" = {
          action = "overview-toggle";
          repeat = false;
        };
        "Mod+W" = {
          action = "overview-toggle";
          repeat = false;
        };

        # Extras do Umbriel, sem equivalente no niri.
        # "Mod" = "spawn noctalia msg panel-toggle launcher"; # Mod sozinho, ao soltar
        # "Mod+Shift+T" = "window-focus-switch-floating";
        # "Mod+P" = "window-toggle-pinned";
        # "Mod+M" = "window-toggle-maximize-to-edges";
        # "Mod+Shift+R" = "window-cycle-primary-extent-back";
        # "Mod+Ctrl+W" = "column-toggle-tabbed";
        # "Mod+Alt+Right" = "column-focus-tab-next";
        # "Mod+Alt+Left" = "column-focus-tab-previous";
        # "Mod+Alt+T" = "layout-toggle-split"; # só no dwindle
        # "Mod+Alt+Space" = "workspace-set-layout toggle";
        # "Mod+MouseMiddle" = "layout-scroll-drag";
        # "Mod+Shift+Space" = "window-move-to-scratchpad";
        # "Mod+Space" = "scratchpad-toggle";
        # "Mod+Ctrl+Space" = "window-restore-from-scratchpad";
        # "Mod+Tab" = "scratchpad-focus-next";
        # "Mod+N" = "window-minimize";
        # "Mod+Shift+N" = "window-restore-minimized";
        # "Mod+Shift+A" = "spawn noctalia msg screenshot-annotate";

        # Submapa: camada temporária de atalhos.
        # "Mod+Shift+P" = { action = "submap power"; repeat = false; };
        # "submap[power],S" = { action = "spawn systemctl suspend"; submap = "reset"; };
        # "submap[power],Escape" = "submap reset";
      };
    };
  };
}
