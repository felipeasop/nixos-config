{ inputs, ... }: {
  flake-file.inputs.noctalia.url = "github:noctalia-dev/noctalia";

  den.aspects.noctalia = {
    homeManager = { pkgs, ... }: {
      imports = [ inputs.noctalia.homeModules.default ];

      # O Noctalia resolve ícones pelo index.theme de cada diretório XDG.
      # Sem este índice no perfil do usuário, ícones disponíveis apenas em
      # resoluções grandes (como o 512x512 do Zed) recebem fallback genérico.
      home.packages = [ pkgs.hicolor-icon-theme ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
      };

      # Os prefixos `|` tornam estas condições alternativas: o serviço só
      # inicia nas sessões em que o Noctalia é a shell escolhida.
      systemd.user.services.noctalia.Unit.ConditionEnvironment = [
        "|XDG_CURRENT_DESKTOP=niri"
        "|XDG_CURRENT_DESKTOP=mango"
      ];
    };
  };
}
