{ den, ... }: {
  den.aspects.dev = {
    includes = with den.aspects; [
      cli
      dev-tools
      ghostty
      git
      jujutsu
      neovim
      zed-editor
    ];
  };
}
