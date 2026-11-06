{ inputs, ... }: {
  flake-file.inputs.noctalia.url = "github:noctalia-dev/noctalia/cachix";

  # Fica no essential para o cache existir antes de o aspect ser incluído.
  den.aspects.essential.nixos.nix.settings = {
    substituters = [ "https://noctalia.cachix.org" ];
    trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  den.aspects.noctalia = {
    homeManager = { pkgs, ... }: {
      imports = [ inputs.noctalia.homeModules.default ];

      # Sem isso os ícones que só estão disponíveis em resoluções grandes usam fallback genérico
      home.packages = [ pkgs.hicolor-icon-theme ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
      };

      # Prefixo `|` = condições alternativas; só inicia quando Noctalia é a shell ativa.
      systemd.user.services.noctalia.Unit.ConditionEnvironment = [
        "|XDG_CURRENT_DESKTOP=niri"
        "|XDG_CURRENT_DESKTOP=mango"
      ];
    };
  };
}
