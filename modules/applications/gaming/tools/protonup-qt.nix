{
  den.aspects.protonup-qt = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.protonup-qt ];
    };
  };
}
