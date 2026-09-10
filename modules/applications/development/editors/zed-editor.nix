{
  den.aspects.zed-editor = {
    homeManager = { pkgs, ... }: {
      programs.zed-editor = {
        enable = true;

        extensions = [
          "everforest-theme"
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
            # Fallback independente do Noctalia: a extensão usa a mesma
            # identidade Everforest configurada como paleta comunitária.
            mode = "dark";
            dark = "Everforest Dark Soft";
          };
        };
      };
    };
  };
}
