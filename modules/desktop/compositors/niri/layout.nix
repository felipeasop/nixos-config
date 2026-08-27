let
  accent = "#a7c080";
  accentDim = "#4e6924";
  accentTranslucent = "#a7c08080";
  inactive = "#232a2e";
  urgent = "#e67e80";
in
{
  den.aspects.niri = {
    homeManager = {
      programs.niri.settings = {
        layout = {
          gaps = 6;
          center-focused-column = "never";

          background-color = "transparent";

          preset-column-widths = [
            { proportion = 0.33333; }
            { proportion = 0.5; }
            { proportion = 0.66667; }
          ];

          default-column-width.proportion = 0.5;

          struts = { };

          focus-ring = {
            width = 1.5;
            active.color = accent;
            inactive.color = inactive;
            urgent.color = urgent;
          };

          border.enable = false;

          shadow.color = "#47525870";

          tab-indicator = {
            active.color = accent;
            inactive.color = accentDim;
            urgent.color = urgent;
          };

          insert-hint.display.color = accentTranslucent;
        };
      };
    };
  };
}
