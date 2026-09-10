{
  den.aspects.starship = {
    homeManager = {
      programs.starship = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;

        settings = {
          add_newline = false;
          scan_timeout = 30;
          # O direnv pode avaliar um ambiente Nix na primeira entrada no
          # diretório; 500 ms gera aviso mesmo quando a avaliação termina.
          command_timeout = 2000;
          palette = "everforest";

          palettes.everforest = {
            fg = "#d3c6aa";
            red = "#e67e80";
            orange = "#e69875";
            yellow = "#dbbc7f";
            green = "#a7c080";
            aqua = "#83c092";
            blue = "#7fbbb3";
            purple = "#d699b6";
            grey = "#859289";
          };
        };
      };
    };
  };
}
