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

      # Version control (git fica fora: sua fatia nixos exige secrets, nem todo host tem)
      jujutsu
      lazygit

      # Editors / IDEs
      zed-editor
    ];
  };
}
