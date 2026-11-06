{
  den.aspects.yazi = {
    nixos = { pkgs, ... }: { environment.systemPackages = [ pkgs.yazi ]; };
  };
}
