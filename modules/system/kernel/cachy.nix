{ inputs, ... }: {
  flake-file.inputs.chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

  den.aspects.cachy-kernel = {
    nixos = { pkgs, ... }: {
      imports = [ inputs.chaotic.nixosModules.default ];
      boot.kernelPackages = pkgs.linuxPackages_cachyos;
    };
  };
}
