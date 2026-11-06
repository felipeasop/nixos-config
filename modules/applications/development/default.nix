{ den, ... }: {
  den.aspects.dev = {
    includes = with den.aspects; [
      # CLI / QOL
      direnv
      fastfetch
      cli
      tmux

      # Terminal emulator
      alacritty

      # Version control
      git
      jujutsu
      lazygit

      # Editors / IDEs
      zed-editor
    ];
  };
}
