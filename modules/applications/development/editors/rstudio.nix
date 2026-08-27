{
  den.aspects.rstudio = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.rstudio ];
    };
  };
}
