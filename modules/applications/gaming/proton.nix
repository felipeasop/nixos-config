{
  den.aspects.proton = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.protonup-qt ];
    };
  };
}
