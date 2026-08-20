{
  den.aspects.zed-editor = {
    homeManager = { pkgs, ... }: {
      programs.zed-editor = {
        enable = true;

        extensions = [
          "nix"
          "toml"
        ];

        extraPackages = with pkgs; [
          nil
          nixd
        ];

        userSettings = {
          buffer_font_family = "JetBrainsMono Nerd Font";
          ui_font_family = "JetBrainsMono Nerd Font";
          buffer_font_size = 14;
          ui_font_size = 14;

          theme = {
            mode = "system";
          };
        };
      };
    };
  };
}
