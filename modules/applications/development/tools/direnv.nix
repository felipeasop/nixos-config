{
  den.aspects.direnv = {
    homeManager = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;

        enableBashIntegration = true;
        enableZshIntegration = true;
        enableFishIntegration = true;

        silent = false;
      };
    };
  };
}
