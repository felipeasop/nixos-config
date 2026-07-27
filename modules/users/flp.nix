{ den, ... }: {
  den.aspects.flp = {
    includes =
      with den.provides;
      with den.aspects;
      [
        define-user
        primary-user
        (user-shell "fish")


        logiops

        dev
        astah
        sql-power-architect
        fish
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
