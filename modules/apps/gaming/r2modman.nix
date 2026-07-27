{
  den.aspects.r2modman = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.r2modman ];
    };
  };
}
