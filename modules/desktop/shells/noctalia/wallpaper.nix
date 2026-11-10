{ inputs, ... }: {
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings = {
        wallpaper = {
          enabled = true;
          fill_mode = "crop"; # center | crop | fit | stretch | repeat | span
          fill_color = "";
          edge_smoothness = 0.3;
          transition = [
            "fade"
            "wipe"
            "disc"
            "stripes"
            "zoom"
            "honeycomb"
          ];
          transition_duration = 1500.0;
          transition_on_startup = false;
          per_monitor_directories = false;

          directory = builtins.path {
            path = "${inputs.self}/assets/wallpaper";
            name = "wallpaper";
          };
          # directory_light = "";
          # directory_dark  = "";

          automation = {
            enabled = false;
            interval_seconds = 1800;
            order = "random";
            recursive = true;
          };
        };

        backdrop = {
          enabled = false; # o papel de parede já vai para o backdrop do niri (niri/rules.nix)
          blur_intensity = 0.5;
          tint_intensity = 0.3;
        };
      };
    };
  };
}
