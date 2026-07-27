{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = { pkgs, ... }: {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        nixfmt.enable = true;
        deadnix.enable = true;
        statix.enable = true;
        shfmt.enable = true;
      };
    };
  };
}
