{
  den.aspects.bash = {
    homeManager = { config, ... }: {
      programs.bash = {
        enable = true;
        historyFile = "${config.xdg.stateHome}/bash/history";
      };
    };
  };
}
