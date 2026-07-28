# uso: nix develop .#rust
{
  perSystem =
    { config, pkgs, ... }:
    let
      pkgSets = with pkgs; {
        c = [
          gcc
          gnumake
          cmake
          gdb
          clang-tools
        ];
        java = [
          jdk21
          maven
          gradle
        ];
        go = [
          go
          gopls
          golangci-lint
          delve
        ];
        rust = [
          rustc
          cargo
          rust-analyzer
          clippy
          rustfmt
          pkg-config
        ];
        python = [
          python3
          python3Packages.pip
          python3Packages.virtualenv
          pyright
        ];
      };
    in
    {
      devShells = (builtins.mapAttrs (_name: packages: pkgs.mkShell { inherit packages; }) pkgSets) // {
        default = pkgs.mkShell {
          shellHook = config.pre-commit.installationScript;
          packages =
            (builtins.concatLists (builtins.attrValues pkgSets))
            ++ (with pkgs; [
              direnv
              nix-direnv
            ]);
        };
      };
    };
}
