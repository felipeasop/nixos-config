{
  den.aspects.essential = {
    nixos = {
      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          trusted-users = [
            "root"
            "flp"
          ];

          substituters = [
            "https://cache.nixos.org/"
            "https://nyx-cache.chaotic.cx/"
            "https://nix-community.cachix.org"
            "https://noctalia.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];

          max-jobs = "auto";
          cores = 0; # Usa todos os nucleos

          accept-flake-config = true;
        };
        optimise = {
          automatic = true;
          dates = [ "03:45" ];
        };
      };
    };
  };
}
