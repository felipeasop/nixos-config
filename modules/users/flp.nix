{ den, ... }: {
  den.aspects.flp = {
    includes = with den.aspects; [
      standard-user

      dev
      fish
      wm
      gaming

      firefox
      librewolf
      zen-browser

      discord
      spotify
      r2modman
      prismlauncher

      solaar
      solaar-m650l # traz solaar junto (dependência declarada no próprio aspect)
    ];
  };
}
