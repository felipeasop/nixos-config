{ inputs, ... }: {
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.stylix.nixos = { pkgs, ... }: {
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

      targets = {
        console.enable = true;
        fish.enable = true;
        font-packages.enable = true;
        fontconfig.enable = true;
        grub.enable = true;
        gtk.enable = true;
        lightdm.enable = true;
        nixos-icons.enable = true;
        qt.enable = true;
      };
    };

    home-manager.sharedModules = [
      {
        stylix.targets = {
          alacritty.enable = true;
          bat.enable = true;
          btop.enable = true;
          firefox.enable = true;
          fish.enable = true;
          font-packages.enable = true;
          fontconfig.enable = true;
          fzf.enable = true;
          gnome.enable = false;
          gtk.enable = true;
          kde.enable = true;
          lazygit.enable = true;
          mangohud.enable = true;
          micro.enable = true;
          niri.enable = true;
          nixcord.enable = true;
          noctalia.enable = true;
          obsidian.enable = true;
          qt.enable = true;
          starship.enable = true;
          tmux.enable = true;
          x11.enable = true;
          yazi.enable = true;
          zed.enable = true;
          zen-browser.enable = true;
        };
      }
    ];
  };
}
