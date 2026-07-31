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
    };

    provides.to-users.homeManager = {
      imports = [ inputs.plasma-manager.homeModules.plasma-manager ];
      programs.plasma = {
        enable = true;
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
