{ den, ... }: {
  den.aspects.flp = {
    includes = with den.aspects; [
      standard-user

      dev
      fish
      wm
      gaming # antes vinha via isGaming=true + identities; agora direto

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
