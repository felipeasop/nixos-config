# https://docs.noctalia.dev/umbriel/appearance/
# Sem target do Stylix: as cores vêm de config.lib.stylix, como no niri.
# Faltam em relação ao niri: cor de urgente na borda (só existe nas abas),
# `background-color = "transparent"` e `clip-to-geometry` (o Umbriel sempre
# recorta pelo corner_radius). A borda aceita só inteiros: o focus-ring de 1.5
# do niri vira 2.
{
  den.aspects.umbriel = {
    homeManager = { config, ... }: {
      programs.umbriel.settings =
        let
          c = config.lib.stylix.colors.withHashtag;
          solid = name: "${c.${name}}FF";
        in
        {
          appearance = {
            prefer_no_csd = true;
            border_width = 2;
            outer_border_width = 0;
            corner_radius = 8; # niri: geometry-corner-radius em rules.nix
            drag_opacity = 0.75;
            opaque_fullscreen = true;

            # Barra de título própria; "negotiated", "on" ou "forced" para ligar.
            title_bar = {
              mode = "off";
              height = 28;
              font = "sans 10";
              button_position = "right";
              buttons = [
                "minimize"
                "maximize"
                "close"
              ];
              button_size = -1;
              button_gap = 8;
              button_padding = -1;
              button_corner_radius = -1;
              button_glyph = "hover";
              button_background = true;
            };

            tab_bar = {
              style = "titles"; # "indicator" é o equivalente ao tab-indicator do niri
              position = "top";
              height = 24;
              font = "sans 10";
              padding = 8;
              tab_gap = 2;
              gap = -1;
              corner_radius = -1;
              title_format = "{title}";
              title_align = "center";
              visible = true;
              hide_when_single = false;
              max_tabs = 0;
              overflow = "scroll";
            };

            # Só age em janelas e camadas com `blur = true` (rules.nix).
            blur = {
              enabled = true;
              optimized = true;
              passes = 2;
              radius = 5;
              noise = 0.02;
              brightness = 0.9;
              contrast = 0.9;
              saturation = 1.1;
            };

            shadow = {
              enabled = false; # desligada no niri (só a cor estava definida)
              softness = 10;
              offset_x = 2;
              offset_y = 2;
            };
          };

          colors = {
            background = solid "base00";
            text_primary = solid "base05";
            text_muted = solid "base04";
            accent_primary = solid "base0B";
            accent_secondary = solid "base0D";
            warning = solid "base0A";
            error = solid "base08";
            insert_hint = "${c.base0B}80";
            backdrop = "#000000FF";
            shadow = "${c.base02}70";

            border = {
              focused = solid "base0B";
              unfocused = solid "base00";
              outer = solid "base01";
            };

            overview = {
              background_tint = "#10101430";
              workspace_background = "#00000044";
              badge = solid "base0B";
            };

            tab_bar = {
              background = solid "base01";
              text = solid "base04";
              active = solid "base0B";
              active_text = solid "base00";
              active_unfocused = "${c.base0B}60";
              active_unfocused_text = solid "base05";
              urgent = solid "base08";
              urgent_text = solid "base00";
            };

            title_bar = {
              background = solid "base01";
              background_unfocused = solid "base00";
              text = solid "base05";
              text_unfocused = solid "base04";
              close = solid "base08";
              close_glyph = solid "base00";
              close_glyph_hover = solid "base00";
              maximize = solid "base0D";
              maximize_glyph = solid "base00";
              maximize_glyph_hover = solid "base00";
              minimize = solid "base0A";
              minimize_glyph = solid "base00";
              minimize_glyph_hover = solid "base00";
            };
          };
        };
    };
  };
}
