{
  den.aspects.gamescope = {
    nixos = {
      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };
      programs.steam.gamescopeSession.enable = true;
    };
  };
}
