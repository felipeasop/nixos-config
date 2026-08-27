{
  den.aspects.discord = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.discord ];
    };
  };
}
