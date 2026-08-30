{ den, ... }: {
  den.aspects.flp = {
    includes = with den.aspects; [
      # Development
      dev
      fish
      codex

      # Desktop
      desktop-stack
      gaming

      # Browsers
      firefox
      librewolf
      zen-browser

      # Utilities
      gimp
      libreoffice
      spotify
      obsidian
      r2modman
      prismlauncher

      solaar
      solaar-m650l # traz solaar junto (dependência declarada no próprio aspect)
    ];
  };
}
