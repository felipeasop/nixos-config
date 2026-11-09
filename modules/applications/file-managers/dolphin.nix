{
  den.aspects.dolphin = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.kdePackages.dolphin ];
    };
  };
}
