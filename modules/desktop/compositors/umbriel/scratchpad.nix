# https://docs.noctalia.dev/umbriel/scratchpad/
# Sem equivalente no niri. Sem entradas há um scratchpad implícito `default`
# (atalhos comentados em binds.nix); definir um nomeado remove o implícito.
{
  den.aspects.umbriel = {
    homeManager = {
      programs.umbriel.settings.scratchpad = [
        # {
        #   name = "music";
        #   spawn_when_empty = "spotify";
        #   proportional_size = true;
        # }
      ];
    };
  };
}
