{ den, ... }: {
  den.aspects.dev = {
    includes = with den.aspects; [
      cli
      direnv
      tmux
      fastfetch
      ghostty
      git
      jujutsu
      lazygit
      neovim
      zed-editor
      rstudio
    ];
  };
}
