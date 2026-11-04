{ inputs, ... }: {
  flake-file.inputs.noctalia.url = "github:noctalia-dev/noctalia/cachix";

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
