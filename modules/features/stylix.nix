{ inputs, ... }:
let
  common = {
    stylix = {
      autoEnable = false;
      # Overlays e o tema do GNOME Shell recompilam pacotes localmente.
      overlays.enable = false;

      targets = {
        font-packages.enable = true;
        fontconfig.enable = true;
        gtk.enable = true;
        qt.enable = true;
      };
    };
  };

  home = { config, lib, ... }: {
    imports = [ common ];

    stylix.targets.x11.enable = true;

    # O cursor já fica em ~/.local/share/icons; a cópia em ~/.icons é legado.
    home.pointerCursor = lib.mkIf (config.stylix.enable && config.stylix.cursor != null) {
      dotIcons.enable = false;
    };
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
      imports = [
        inputs.stylix.nixosModules.stylix
        common
      ];

      stylix.targets.nixos-icons.enable = true;

      home-manager.sharedModules = [ home ];
    };

    # Só homes standalone; em hosts o módulo NixOS importa o do Home Manager.
    homeManager = {
      imports = [
        inputs.stylix.homeModules.stylix
        home
      ];
    };
  };
}
