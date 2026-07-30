{ inputs, lib, ... }: {
  flake-file.inputs = {
    flake-file.url = "github:denful/flake-file";
    den.url = "github:denful/den";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    git-hooks.url = "github:cachix/git-hooks.nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  imports = [ inputs.flake-file.flakeModules.default ];

  flake-file.outputs = lib.mkDefault "dendritic";
}
