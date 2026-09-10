{ inputs, ... }: {
  flake-file.inputs.git-hooks = {
    url = "github:cachix/git-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    {
      config,
      lib,
      self',
      ...
    }:
    {
      devShells.default = config.pre-commit.devShell;

      pre-commit = {
        check.enable = false;
        settings.hooks = {
          treefmt = {
            enable = true;
            entry = lib.mkForce (lib.getExe self'.formatter);
          };
          deadnix.enable = true;
          statix = {
            enable = true;
            pass_filenames = true;
            # _hardware.nix é autogerado pelo nixos-generate-config
            # (cabeçalho "DO NOT MODIFY")
            # Excluído por padrão de nome, cobre qualquer host
            excludes = [ "_hardware\\.nix$" ];
          };
        };
      };
    };
}
