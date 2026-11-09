{
  den.aspects.zed-editor = {
    homeManager = { lib, pkgs, ... }: {
      stylix.targets.zed.fonts.enable = false;

      programs.zed-editor = {
        enable = true;

        extensions = [ "toml" ];

        userSettings = {
          node = {
            path = lib.getExe pkgs.nodejs;
            npm_path = lib.getExe' pkgs.nodejs "npm";
          };

          buffer_font_family = "JetBrainsMono Nerd Font";
          ui_font_family = "JetBrainsMono Nerd Font";
          buffer_font_size = 14;
          ui_font_size = 14;
        };
      };
    };
  };
}
