{ inputs, ... }: {
  flake-file.inputs.chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

  den.aspects = {
    # Fica no essential para o cache existir antes de o aspect ser incluído.
    essential = {
      nixos = {
        nix.settings = {
          substituters = [ "https://nyx-cache.chaotic.cx/" ];
          trusted-public-keys = [ "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk=" ];
        };
      };
    };

    cachy-kernel = {
      nixos = { pkgs, ... }: {
        imports = [ inputs.chaotic.nixosModules.default ];
        chaotic.nyx.cache.enable = false;
        boot.kernelPackages = pkgs.linuxPackages_cachyos;
      };
    };
  };
}
