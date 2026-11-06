{ inputs, ... }: {
  flake-file.inputs.plasma-manager = {
    url = "github:nix-community/plasma-manager";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      home-manager.follows = "home-manager";
    };
  };

  den.aspects.kde = {
    nixos = { pkgs, ... }: {
      services = {
        displayManager.sddm.enable = true;
        desktopManager.plasma6.enable = true;
      };

      programs.kde-pim.enable = false;

      environment.plasma6.excludePackages = with pkgs.kdePackages; [ discover ];

      # SDDM (tela de login) lê o ícone via accountsservice.
      system.activationScripts.userAvatar.text = ''
        mkdir -p /var/lib/AccountsService/icons
        cp ${inputs.self}/assets/avatar/margarida.jpg /var/lib/AccountsService/icons/flp
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

        kwin.virtualDesktops = {
          number = 4;
          rows = 1;
          names = [
            "1"
            "2"
            "3"
            "4"
          ];
        };

        shortcuts = {
          kwin = {
            "Switch to Desktop 1" = "Meta+1";
            "Switch to Desktop 2" = "Meta+2";
            "Switch to Desktop 3" = "Meta+3";
            "Switch to Desktop 4" = "Meta+4";
            "Window to Desktop 1" = "Meta+Ctrl+1";
            "Window to Desktop 2" = "Meta+Ctrl+2";
            "Window to Desktop 3" = "Meta+Ctrl+3";
            "Window to Desktop 4" = "Meta+Ctrl+4";
          };

          plasmashell = {
            "activate task manager entry 1" = "none";
            "activate task manager entry 2" = "none";
            "activate task manager entry 3" = "none";
            "activate task manager entry 4" = "none";
            "activate task manager entry 5" = "none";
            "activate task manager entry 6" = "none";
            "activate task manager entry 7" = "none";
            "activate task manager entry 8" = "none";
            "activate task manager entry 9" = "none";
            "activate task manager entry 10" = "none";
          };

          "services/plasma-manager-commands.desktop"."launch-alacritty" = "Meta+Return";
        };

        session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";

        # O seletor de arquivos do portal KDE lê o tema do kdeglobals, não do GTK.
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

        hotkeys.commands."launch-alacritty" = {
          name = "Launch Alacritty";
          key = "Meta+Return";
          command = "alacritty";
        };
      };
    };
  };
}
