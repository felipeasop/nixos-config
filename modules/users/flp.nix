{ den, ... }: {
  den.aspects.flp = {
    includes = with den.aspects; [
      standard-user

      logiops

      dev
      fish
      wm

      firefox
      librewolf
      zen-browser

      discord
      spotify
      r2modman

      solaar
      solaar-m650l # traz solaar junto (dependência declarada no próprio aspect)
    ];

  };
}
