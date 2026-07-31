{
  den.aspects.dev-tools = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        # C/C++
        gcc
        gdb
        clang-tools
        cmake
        gnumake

        # Java
        jdk21
        maven
        gradle

        # Go
        go
        gopls
        golangci-lint
        delve

        # Rust
        rustc
        cargo
        rust-analyzer
        clippy
        rustfmt

        # Python
        python3
        pyright
        python3Packages.pip

        # direnv, pra integrar com os devShells por projeto
        direnv
        nix-direnv
      ];

      programs = {
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
        bash.enable = true;
      };
    };
  };
}
