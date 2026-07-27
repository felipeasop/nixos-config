{ den, ... }: {
  den.aspects.flp = {
    includes =
      with den.aspects;
      [
        standard-user

        logiops

        dev
        fish
        astah
        sql-power-architect
        wm

        firefox
        librewolf
        zen-browser

        discord
        spotify
        r2modman
        solaar
      ];

  };
}
