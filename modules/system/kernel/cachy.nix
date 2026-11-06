{ inputs, ... }: {
  flake-file.inputs.chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

  # Fica no essential para o cache existir antes de o aspect ser incluído.
  den.aspects.essential.nixos.nix.settings = {
    substituters = [ "https://nyx-cache.chaotic.cx/" ];
    trusted-public-keys = [ "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk=" ];
  };

  den.aspects.cachy-kernel = {
    nixos = { pkgs, ... }: {
      imports = [ inputs.chaotic.nixosModules.default ];
      chaotic.nyx.cache.enable = false;
      boot.kernelPackages = pkgs.linuxPackages_cachyos;
    };
  };
}
