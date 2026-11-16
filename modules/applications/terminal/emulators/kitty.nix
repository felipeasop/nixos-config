{
  den.aspects.kitty = {
    homeManager = {
      stylix.targets.kitty.enable = true;

      programs.kitty = {
        enable = true;
        settings = {
          window_padding_width = 6;
          scrollback_lines = 10000;
          enable_audio_bell = false;
          mouse_hide_wait = -1;
        };
        keybindings."ctrl+shift+a" = "launch --stdin-source=@screen_scrollback --type=clipboard";
      };

      xdg.terminal-exec = {
        enable = true;
        settings.default = [ "kitty.desktop" ];
      };
    };
  };
}
