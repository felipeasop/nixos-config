# uso: nix develop .#rust
{
  perSystem = { config, pkgs, ... }: {
    devShells = {
      c = pkgs.mkShell {
        packages = with pkgs; [
          gcc
          gnumake
          cmake
          gdb
          clang-tools
        ];
      };

      java = pkgs.mkShell {
        packages = with pkgs; [
          jdk21
          maven
          gradle
        ];
      };

      go = pkgs.mkShell {
        packages = with pkgs; [
          go
          gopls
          golangci-lint
          delve
        ];
      };

      rust = pkgs.mkShell {
        packages = with pkgs; [
          rustc
          cargo
          rust-analyzer
          clippy
          rustfmt
          pkg-config
        ];
      };

      python = pkgs.mkShell {
        packages = with pkgs; [
          python3
          python3Packages.pip
          python3Packages.virtualenv
          pyright
        ];
      };

      # Shell combinado, pra quando um projeto mistura linguagens
      default = pkgs.mkShell {
        shellHook = config.pre-commit.installationScript;
        packages = with pkgs; [
          gcc
          gnumake
          cmake
          gdb
          clang-tools
          jdk21
          maven
          gradle
          go
          gopls
          golangci-lint
          delve
          rustc
          cargo
          rust-analyzer
          clippy
          rustfmt
          pkg-config
          python3
          python3Packages.pip
          python3Packages.virtualenv
          pyright
          direnv
          nix-direnv
        ];
      };
    };
  };
}
