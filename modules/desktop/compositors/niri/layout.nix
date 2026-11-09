{
  den.aspects.niri = {
    homeManager = { config, ... }: {
      stylix.targets.niri.enable = true;

      programs.niri.settings.layout =
        let
          c = config.lib.stylix.colors.withHashtag;
        in
        {
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
            active.color = c.base0B;
            inactive.color = c.base00;
            urgent.color = c.base08;
          };

          border.enable = false;

          shadow.color = "${c.base02}70";

          tab-indicator = {
            active.color = c.base0B;
            inactive.color = "${c.base0B}60";
            urgent.color = c.base08;
          };

          insert-hint.display.color = "${c.base0B}80";
        };
    };
  };
}
