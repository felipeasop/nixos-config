{ den, ... }: {
  den.aspects.dev = {
    includes = with den.aspects; [
      cli
      dev-tools
      fastfetch
      ghostty
      git
      jujutsu
      neovim
      zed-editor
    ];
  };
}
