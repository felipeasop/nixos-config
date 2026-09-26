{ den, ... }: {
  den.aspects.dev = {
    includes = with den.aspects; [
      # CLI / QOL
      direnv
      fastfetch
      cli
      tmux

      # Terminal emulator
      foot
      ghostty

      # Version control
      git
      jujutsu
      lazygit

      # Editors / IDEs
      arduino
      neovim
      zed-editor
      rstudio
    ];
  };
}
