{ den, ... }: {
  den.aspects.flp = {
    includes = with den.aspects; [
      standard-user

      dev
      codex
      fish
      wm
      gaming

      firefox
      librewolf
      zen-browser

      discord
      zapzap
      spotify
      obsidian
      r2modman
      prismlauncher

      solaar
      solaar-m650l # traz solaar junto (dependência declarada no próprio aspect)
    ];
  };
}
