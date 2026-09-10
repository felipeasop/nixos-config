{ inputs, ... }: {
  flake-file.inputs.treefmt-nix = {
    url = "github:numtide/treefmt-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = _: {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        nixfmt.enable = true;
        deadnix.enable = true;
        statix = {
          enable = true;
          # Arquivos produzidos por nixos-generate-config não são mantidos
          # manualmente e podem conter atribuições repetidas legítimas.
          excludes = [ "**/_hardware.nix" ];
        };
        shfmt.enable = true;
      };
    };
  };
}
