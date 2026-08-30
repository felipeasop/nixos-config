{ inputs, lib, ... }: {
  flake-file = {
    inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      flake-file.url = "github:denful/flake-file";
      flake-parts.url = "github:hercules-ci/flake-parts";
      import-tree.url = "github:denful/import-tree";

      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };

    outputs = lib.mkDefault "dendritic";
  };

  imports = [ inputs.flake-file.flakeModules.default ];
}
