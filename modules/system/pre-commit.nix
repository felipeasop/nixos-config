{ inputs, ... }: {
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem = { lib, self', ... }: {
    pre-commit.settings.hooks = {
      treefmt = {
        enable = true;
        entry = lib.mkForce (lib.getExe self'.formatter);
      };
      deadnix.enable = true;
      statix.enable = true;
    };
    pre-commit.check.enable = false;
  };
}
