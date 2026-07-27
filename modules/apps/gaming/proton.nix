{
  den.aspects.proton = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.protonup-qt ];
    };
  };
}
