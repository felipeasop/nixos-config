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

      commitMsgStyle = lib.getExe (
        pkgs.writeShellApplication {
          name = "commit-msg-style";
          text = ''
            fail() {
              printf 'commit-msg: %s\n' "$1" >&2
              printf 'Modelo: "escopo: resumo no imperativo", linha vazia, corpo.\n' >&2
              exit 1
            }

            msg=$(grep -v '^#' "$1" || true)
            subject=$(head -n 1 <<<"$msg")

            case "$subject" in
              "Merge "* | "Revert "* | "fixup! "* | "squash! "*) exit 0 ;;
            esac

            scope='[a-z0-9][a-z0-9._/+-]*'
            [[ $subject =~ ^$scope(,\ $scope)*:\ [^[:space:]] ]] || fail "assunto fora do formato"
            (( ''${#subject} <= 72 )) || fail "assunto com mais de 72 caracteres"
            [[ -z $(sed -n 2p <<<"$msg") ]] || fail "a segunda linha deve ficar vazia"
            [[ -n $(tail -n +3 <<<"$msg" | tr -d '[:space:]') ]] || fail "corpo obrigatório"
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
          commit-msg-style = {
            enable = true;
            name = "commit-msg-style";
            entry = commitMsgStyle;
            stages = [ "commit-msg" ];
          };
        };
      };
    };
}
