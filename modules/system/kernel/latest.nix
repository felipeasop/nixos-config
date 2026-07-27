{
  den.aspects.latest-kernel = {
    nixos = { pkgs, ... }: {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
  };
}
