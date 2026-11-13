{ inputs, ... }:
let
  settings = {
    autoEnable = false;
    # Overlays e o tema do GNOME Shell recompilam pacotes localmente.
    overlays.enable = false;
  };

  homeTargets = {
    font-packages.enable = true;
    fontconfig.enable = true;
    gtk.enable = true;
    qt.enable = true;
    x11.enable = true;
  };
in
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      flake-parts.follows = "flake-parts";
    };
  };

  den.aspects.stylix = {
    nixos = {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = settings // {
        targets = {
          font-packages.enable = true;
          fontconfig.enable = true;
          gtk.enable = true;
          nixos-icons.enable = true;
          qt.enable = true;
        };
      };

      home-manager.sharedModules = [
        {
          stylix = settings // {
            targets = homeTargets;
          };
        }
      ];
    };

    # Só homes standalone; em hosts o módulo NixOS importa o do Home Manager.
    homeManager = {
      imports = [ inputs.stylix.homeModules.stylix ];
      stylix = settings // {
        targets = homeTargets;
      };
    };
  };
}
