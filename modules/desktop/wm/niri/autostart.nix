{
  den.aspects.niri = {
    homeManager = {
      # noctalia sobe via systemd user service
      # Não é necessário subir aqui também via spawn-at-startup
      programs.niri.settings.spawn-at-startup = [ ];
    };
  };
}
