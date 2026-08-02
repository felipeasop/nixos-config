{
  den.aspects.zed-editor = {
    homeManager = {
      programs.zed-editor = {
        enable = true;

        extensions = [
          "nix"
          "toml"
        ];

        userSettings = {
          buffer_font_family = "JetBrainsMono Nerd Font";
          ui_font_family = "JetBrainsMono Nerd Font";
          buffer_font_size = 14;
          ui_font_size = 14;

          theme = {
            mode = "system"
          };
        };
      };
    };
  };
}
