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
    };

    provides.to-users = {
      homeManager = { lib, ... }: {
        imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

        programs.plasma = {
          enable = true;
          session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
        };

        # O lado NixOS já tematiza o Qt pelo Plasma; no Home Manager o alvo
        # só suporta qtct e avisaria com a plataforma kde herdada.
        stylix.targets.qt.enable = lib.mkForce false;
      };
    };
  };
}
