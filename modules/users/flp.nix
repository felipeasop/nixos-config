{ den, ... }: {
  den.aspects.flp = {
    includes = with den.aspects; [
      standard-user

      dev
      codex
      fish
      desktop-stack
      gaming

      firefox
      librewolf
      zen-browser

      discord
      zapzap
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
