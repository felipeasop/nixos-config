{
  den.aspects.gamescope = {
    nixos = {
      programs = {
        gamescope = {
          enable = true;
          capSysNice = true;
        };
        steam.gamescopeSession.enable = true;
      };
    };
  };
}
