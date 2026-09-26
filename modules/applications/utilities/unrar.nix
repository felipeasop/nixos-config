{
  den.aspects.unrar = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.unrar ];
    };
  };
}
