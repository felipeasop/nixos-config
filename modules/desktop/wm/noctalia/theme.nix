{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings.theme = {
        mode = "dark"; # dark | light | auto
        source = "community"; # builtin | wallpaper | community | custom
        builtin = "Gruvbox"; # Ayu, Catppuccin, Dracula, Eldritch, Gruvbox, Kanagawa, Noctalia, Nord, Rosé Pine, Tokyo-Night
        pure_black_dark = false; # true = fundo #000 puro no modo dark (bom p/ OLED)
        community_palette = "Everforest";
        # wallpaper_scheme  = "m3-content";  # m3-tonal-spot, m3-content, m3-fruit-salad, m3-rainbow, m3-monochrome, vibrant, faithful, soft, dysfunctional, muted
        # custom_palette    = "";            # nome do arquivo em ~/.config/noctalia/palettes/<nome>.json

        templates = {
          enable_builtin_templates = true;
          enable_community_templates = false;
          builtin_ids = [
            "gtk3"
            "gtk4"
            "qt"
            "kcolorscheme"
            "btop"
            "niri"
            "ghostty"
          ];
          community_ids = [
            "zen-browser"
            "neovim"
            "obsidian"
            "zed"
            "bat"
            "discord"
            "lazygit"
            "prismlauncher"
            "steam"
            "yazi"
          ];
        };
      };
    };
  };
}
