{
  den.aspects.proton-vpn = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.protonvpn-gui ];
    };
  };
}
