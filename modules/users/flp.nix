{ den, ... }: {
  den.aspects.flp = {
    includes = with den.aspects; [
      # Development
      dev
      fish
      codex

      # Desktop
      desktop-stack

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
      solaar-m650l # traz solaar junto (dependência declarada no próprio aspect)
    ];
  };
}
