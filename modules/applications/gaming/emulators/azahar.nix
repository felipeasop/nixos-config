{
  den.aspects.azahar = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.azahar ];
    };
  };
}
