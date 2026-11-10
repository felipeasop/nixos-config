# Cada arquivo leva o nome da seção de `programs.niri.settings` que define;
# move-to-new-workspace.nix é uma funcionalidade própria (script + atalhos).
{ inputs, ... }: {
  flake-file.inputs.niri = {
    url = "github:sodiboo/niri-flake";
    # nixpkgs-stable só alimenta o closure de CI do niri-flake.
    inputs = {
      nixpkgs.follows = "nixpkgs";
      nixpkgs-stable.follows = "nixpkgs";
    };
  };

  flake-duplicates.allowed = {
    "niri/niri-stable" = "o niri-flake empacota de propósito a versão estável e a unstable";
    "niri/xwayland-satellite-stable" =
      "o niri-flake empacota de propósito a versão estável e a unstable";
  };

  den.aspects.niri = {
    description = ''
      Niri: compositor Wayland em tiling scrollável (https://github.com/YaLTeR/niri)

      Configurado via https://github.com/sodiboo/niri-flake.
    '';

    provides.to-hosts = {
      nixos = { pkgs, ... }: {
        imports = [ inputs.niri.nixosModules.niri ];

        programs.niri = {
          enable = true;
          package = pkgs.niri;
        };

        environment.systemPackages = [ pkgs.xwayland-satellite ];
      };
    };
  };
}
