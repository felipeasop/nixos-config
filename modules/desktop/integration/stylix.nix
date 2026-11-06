{ inputs, ... }: {
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.graphical.nixos = { pkgs, ... }: {
    imports = [ inputs.stylix.nixosModules.stylix ];

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
      polarity = "dark";

      cursor = {
        name = "breeze_cursors";
        package = pkgs.kdePackages.breeze;
        size = 24;
      };

      fonts = {
        monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };
        sansSerif = {
          name = "Inter";
          package = pkgs.inter;
        };
        sizes = {
          applications = 10;
          desktop = 10;
          terminal = 14;
        };
      };

      opacity.terminal = 0.92;

      # Overlays e o tema do GNOME Shell recompilam pacotes localmente.
      overlays.enable = false;
    };

    home-manager.sharedModules = [ { stylix.targets.gnome.enable = false; } ];
  };
}
