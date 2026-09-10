{ den, ... }: {
  den.aspects.flp = {
    includes = with den.aspects; [
      # Development
      dev
      fish
      starship
      codex

      # Desktop
      niri-stack
      mango-stack

      # Browsers
      firefox
      librewolf
      zen-browser

      # Utilities
      gimp
      libreoffice

      # Gaming
      gaming-stack

      # Misc
      discord
      zapzap
      spotify
      obsidian

      # Mouse
      solaar
    ];
  };
}
