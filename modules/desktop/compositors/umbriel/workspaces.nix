# https://docs.noctalia.dev/umbriel/workspaces/
# Dinâmicos por monitor, como no niri. Quantidade, eixo e ciclo ficam em
# cada `output` (outputs.nix).
{
  den.aspects.umbriel = {
    homeManager = {
      programs.umbriel.settings = {
        workspaces = {
          back_and_forth = true; # niri: workspace-auto-back-and-forth
          empty_above = false;
        };

        # Workspaces nomeados e layout por workspace.
        # workspace = [
        #   {
        #     name = "web";
        #     output = "DP-1";
        #     layout.mode = "master";
        #   }
        #   {
        #     index = 3;
        #     layout = { mode = "dwindle"; gap = 4; };
        #   }
        # ];
      };
    };
  };
}
