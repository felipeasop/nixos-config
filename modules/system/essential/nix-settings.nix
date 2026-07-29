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

          # Caches binários. IMPORTANTE: `substituters` aqui SUBSTITUI a lista
          # padrão (que inclui https://cache.nixos.org/), não soma a ela. Por
          # isso listamos o cache oficial explicitamente, junto dos extras.
          substituters = [
            "https://cache.nixos.org/"
            "https://chaotic-nyx.cachix.org"
            "https://nix-community.cachix.org"
            "https://noctalia.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "https://noctalia.cachix.org"
          ];

          # Usa todos os núcleos disponíveis tanto pra rodar builds em paralelo
          # quanto pra compilar cada derivação (make -jN, etc).
          max-jobs = "auto";
          cores = 0; # 0 = usa todos os cores da máquina

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
