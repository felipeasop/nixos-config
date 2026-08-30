{
  den.aspects.eden = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.eden ];
    };
  };
}
