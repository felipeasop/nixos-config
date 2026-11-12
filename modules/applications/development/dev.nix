{ den, ... }: {
  den.aspects.dev = {
    includes = with den.aspects; [
      # CLI / QOL
      direnv
      fastfetch
      cli
      tmux

      # Terminal emulator
      kitty

      # Version control
      git
      jujutsu
      lazygit

      # Editors / IDEs
      zed-editor
    ];
  };
}
