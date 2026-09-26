{
  den.aspects.arduino = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.arduino-ide ];
    };
  };
}
