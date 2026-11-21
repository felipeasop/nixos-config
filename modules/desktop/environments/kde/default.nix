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
        orca.enable = false;
      };

      programs.kde-pim.enable = false;

      environment.plasma6.excludePackages = with pkgs.kdePackages; [ discover ];
    };

    homeManager = { lib, ... }: {
      imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

      programs.plasma = {
        enable = true;
        session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
        configFile.krunnerrc.Plugins.krunner_appstreamEnabled = false;
        # Ao acordar o monitor, a restauração do brilho por DDC/CI falha e o valor real diverge do mostrado.
        powerdevil.AC.dimDisplay.enable = false;
      };

      stylix.targets = {
        kde.enable = true;
        # O lado NixOS já tematiza o Qt pelo Plasma; no Home Manager o alvo
        # só suporta qtct e avisaria com a plataforma kde herdada.
        qt.enable = lib.mkForce false;
      };
    };
  };
}
