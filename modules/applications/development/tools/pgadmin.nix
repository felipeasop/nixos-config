{
  den.aspects.pgadmin = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.pgadmin4-desktopmode ];
    };
  };
}
