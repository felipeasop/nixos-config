{ config, lib, ... }:
let
  inherit (config.flake-duplicates) allowed;
in
{
  options.flake-duplicates.allowed = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    example = {
      "noctalia/nixpkgs" = "o cache do noctalia é gerado com o nixpkgs fixado por ele";
    };
    description = ''
      Inputs transitivos, pelo caminho a partir da raiz (`pai/input`), que podem
      repetir um projeto já presente no flake.lock, cada um com o motivo.
    '';
  };

  config.perSystem = { pkgs, ... }: {
    pre-commit.settings.hooks.flake-duplicates = {
      enable = true;
      name = "flake-duplicates";
      files = "^flake\\.lock$";
      entry = lib.getExe (
        pkgs.writeShellApplication {
          name = "flake-duplicates";
          runtimeInputs = [ pkgs.jq ];
          text = ''
            status=0

            for lock in "$@"; do
              report=$(jq -r --argjson allowed ${lib.escapeShellArg (builtins.toJSON allowed)} -f ${./flake-duplicates.jq} "$lock")
              if [[ -n $report ]]; then
                printf '%s: projeto repetido; use follows ou registre em flake-duplicates.allowed\n%s\n' "$lock" "$report" >&2
                status=1
              fi
            done

            exit "$status"
          '';
        }
      );
    };
  };
}
