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
      pkgs,
      self',
      ...
    }:
    let
      deadnixStaged = lib.getExe (
        pkgs.writeShellApplication {
          name = "deadnix-staged";
          runtimeInputs = [ pkgs.deadnix ];
          text = ''
            if (( $# == 0 )); then
              exit 0
            fi

              exec deadnix --fail "$@"
          '';
        }
      );

      statixStaged = lib.getExe (
        pkgs.writeShellApplication {
          name = "statix-staged";
          runtimeInputs = [ pkgs.statix ];
          text = ''
            status=0

            for target in "$@"; do
              statix check --format errfmt "$target" || status=$?
            done

            exit "$status"
          '';
        }
      );
    in
    {
      devShells.default = config.pre-commit.devShell;

      pre-commit = {
        check.enable = false;
        settings.hooks = {
          treefmt = {
            enable = true;
            entry = lib.mkForce (lib.getExe self'.formatter);
          };
          deadnix = {
            enable = true;
            always_run = true;
            entry = lib.mkForce deadnixStaged;
          };
          statix = {
            enable = true;
            always_run = true;
            entry = lib.mkForce statixStaged;
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
