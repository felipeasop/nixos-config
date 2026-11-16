# https://docs.noctalia.dev/umbriel/effects/
# Efeitos GLSL, sem equivalente no niri; todos desligados. Para usar um
# embutido, inclua o preset (general.nix, `include.files`) a partir de
# /etc/profiles/per-user/<usuário>/share/umbriel/effects/<tipo>/<nome>/effect.toml
# ou /run/current-system/sw/share/umbriel/effects/... e selecione pelo nome.
{
  den.aspects.umbriel = {
    homeManager = {
      programs.umbriel.settings.effects = {
        border = "";
        window = "";
        screen = "";
        screen_cast = "";
        cursor = "";
        max_fps = 0;
        in_capture = false;
        border_unfocused = false;

        # pool.borders = {
        #   kind = "border";
        #   choose = [ "pulse" ];
        #   selection = "unused_first"; # "round_robin" ou "random"
        # };
      };
    };
  };
}
