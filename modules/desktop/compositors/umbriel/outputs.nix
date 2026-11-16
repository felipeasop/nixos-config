# https://docs.noctalia.dev/umbriel/outputs/
# Monitores; liste-os com `umbriel outputs`. Exemplo com todas as chaves:
#
# output."eDP-1" = {
#   enabled = true;
#   focus_at_startup = false;
#   mode = "1920x1080@60";
#   position = [ 0 0 ];
#   scale = 1.0;
#   transform = "normal";
#   vrr = "disabled"; # "always" ou "fullscreen"
#   tearing = false;
#   direct_scanout = true;
#   hdr = "off"; # "on", "auto" ou "fullscreen"
#   sdr_white = 203;
#   sdr_transfer = "gamma22";
#   bit_depth = 8;
#   workspaces = "dynamic"; # ou um número, ou uma lista de nomes
#   min_workspaces = 1;
#   cyclic_workspaces = false;
#   workspace_axis = "vertical";
#   layout.scrolling.default_extent_fraction = 0.5;
# };
{
  den.aspects.umbriel = {
    homeManager = {
      programs.umbriel.settings.output = { };
    };
  };
}
