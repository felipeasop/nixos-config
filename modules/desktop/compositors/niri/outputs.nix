# Aspect niri — monitores. Liste-os com `niri msg outputs`; exemplo:
#
# outputs."eDP-1" = {
#   scale = 1.0;
#   mode.width = 1920;
#   mode.height = 1080;
#   mode.refresh = 60.000;
# };
{
  den.aspects.niri = {
    homeManager = {
      programs.niri.settings.outputs = { };
    };
  };
}
