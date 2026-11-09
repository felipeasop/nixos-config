{
  den.aspects.r2modman = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.r2modman ];
    };
  };
}
