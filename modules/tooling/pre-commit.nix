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

      # O W20 do statix só dispara com três ou mais repetições; grouped-attrpaths pega a partir de duas.
      nixStyleRules = pkgs.writeText "nix-style.yml" ''
        id: grouped-attrpaths
        language: nix
        severity: error
        message: "`$K` aparece em mais de uma atribuição deste attrset; agrupe em `$K = { ... };`."
        rule:
          kind: binding
          has:
            field: attrpath
            has:
              nthChild: 1
              pattern: $K
          precedes:
            stopBy: end
            kind: binding
            has:
              field: attrpath
              has:
                nthChild: 1
                pattern: $K
        ---
        id: class-binding
        language: nix
        severity: error
        message: "Declare a classe como atribuição própria (`nixos = { ... };`), não dentro de um caminho."
        rule:
          kind: binding
          has:
            field: attrpath
            all:
              - has:
                  kind: identifier
                  regex: "^(nixos|homeManager)$"
              - not:
                  regex: "^(nixos|homeManager)$"
          not:
            inside:
              stopBy: end
              kind: binding
              has:
                field: attrpath
                has:
                  kind: identifier
                  regex: "^(nixos|homeManager)$"
        ---
        id: class-block
        language: nix
        severity: error
        message: "Abra o bloco da classe em várias linhas: `nixos = {`, conteúdo, `};`."
        rule:
          kind: binding
          all:
            - has:
                field: attrpath
                regex: "^(nixos|homeManager)$"
            - has:
                field: expression
                kind: attrset_expression
                has:
                  kind: binding_set
                not:
                  regex: "\n"
        ---
        id: class-function-head
        language: nix
        severity: error
        message: "Mantenha o cabeçalho da classe numa linha: `nixos = { pkgs, ... }: {`."
        rule:
          kind: binding
          all:
            - has:
                field: attrpath
                regex: '^(nixos|homeManager)$'
            - has:
                field: expression
                kind: function_expression
                all:
                  - has:
                      field: body
                      kind: attrset_expression
                  - not:
                      has:
                        field: formals
                        regex: '\n'
            - not:
                regex: '^[^\n]*:[ \t]*\{'
        ---
        id: class-function-block
        language: nix
        severity: error
        message: "Abra o corpo da classe em várias linhas: `nixos = { pkgs, ... }: {`, conteúdo, `};`."
        rule:
          kind: binding
          all:
            - has:
                field: attrpath
                regex: '^(nixos|homeManager)$'
            - has:
                field: expression
                kind: function_expression
                has:
                  field: body
                  kind: attrset_expression
                  has:
                    kind: binding_set
                  not:
                    regex: '\n'
      '';

      nixStyle = lib.getExe (
        pkgs.writeShellApplication {
          name = "nix-style";
          runtimeInputs = [ pkgs.ast-grep ];
          text = ''
            if (( $# == 0 )); then
              exit 0
            fi

            exec ast-grep scan --rule ${nixStyleRules} "$@"
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
          nix-style = {
            enable = true;
            name = "nix-style";
            entry = nixStyle;
            files = "\\.nix$";
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
