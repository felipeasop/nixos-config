{ inputs, ... }: {
  flake-file.inputs.plasma-manager = {
    url = "github:nix-community/plasma-manager";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      home-manager.follows = "home-manager";
    };
  };

  den.aspects.kde = {
    nixos = {
      services = {
        displayManager.sddm.enable = true;
        desktopManager.plasma6.enable = true;
      };

      # SDDM (tela de login) lê o ícone via accountsservice.
      system.activationScripts.userAvatar.text = ''
        mkdir -p /var/lib/AccountsService/icons
        cp ${../../../assets/avatar/margarida.jpg} /var/lib/AccountsService/icons/flp
        chmod 644 /var/lib/AccountsService/icons/flp
      '';

      environment.etc."accountsservice/users/flp".text = ''
        [User]
        Icon=/var/lib/AccountsService/icons/flp
      '';
    };

    provides.to-users.homeManager = {
      imports = [ inputs.plasma-manager.homeModules.plasma-manager ];
      programs.plasma = {
        enable = true;

        # Dolphin/kdialog (usados pelo xdg-desktop-portal-kde no
        # FileChooser) leem tema de ~/.config/kdeglobals, não do
        # dconf/GTK que já configuramos em xdg.nix.
        workspace = {
          theme = "breeze-dark";
          colorScheme = "BreezeDark";
        };

        input.mice = [
          {
            name = "Logitech USB Receiver Mouse";
            vendorId = "046D";
            productId = "C548";
            accelerationProfile = "none";
            acceleration = 0.0;
          }
        ];
        shortcuts.kwin = {
          "Ghostty" = "Meta+Enter";
        };
      };
    };
  };
}
