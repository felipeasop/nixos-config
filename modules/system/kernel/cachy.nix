{ inputs, ... }: {
  den.aspects.cachy-kernel = {
    nixos = { pkgs, ... }: {
      imports = [ inputs.chaotic.nixosModules.default ];
      boot.kernelPackages = pkgs.linuxPackages_cachyos;
    };
  };
}
