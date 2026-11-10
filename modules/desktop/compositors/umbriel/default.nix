{ inputs, ... }: {
  flake-file.inputs.umbriel.url = "github:noctalia-dev/umbriel/cachix";

  flake-duplicates.allowed."umbriel/nixpkgs" =
    "o umbriel.cachix é gerado com o nixpkgs fixado pelo umbriel";

  den.aspects = {
    # Fica no essential para o cache existir antes de o aspect ser incluído.
    essential = {
      nixos = {
        nix.settings = {
          substituters = [ "https://umbriel.cachix.org" ];
          trusted-public-keys = [ "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw=" ];
        };
      };
    };

    umbriel = {
      provides.to-hosts = {
        nixos = {
          imports = [ inputs.umbriel.nixosModules.default ];
          programs.umbriel.enable = true;
        };
      };

      homeManager = {
        imports = [ inputs.umbriel.homeModules.default ];
        programs.umbriel.enable = true;

        systemd.user.services.noctalia.Unit.ConditionEnvironment = [ "|XDG_CURRENT_DESKTOP=umbriel" ];
      };
    };
  };
}
