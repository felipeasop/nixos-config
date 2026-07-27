{ inputs, ... }: {
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem = { config, ... }: {
    pre-commit.settings.hooks = {
      treefmt.enable = true;
      deadnix.enable = true;
      statix.enable = true;
    };
    pre-commit.check.enable = false;
  };
}
