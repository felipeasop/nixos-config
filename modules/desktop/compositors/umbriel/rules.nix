# https://docs.noctalia.dev/umbriel/window-rules/ e /umbriel/layer-rules/
# Regex ECMAScript; todas as regras que casam somam, a última vence. Sem
# `excludes` como no niri: a exclusão vira lookahead negativo no título.
# Sem equivalente: place-within-backdrop do wallpaper do Noctalia (o overview do
# Umbriel já mostra o fundo em cada workspace, `workspace_wallpaper`).
{
  den.aspects.umbriel = {
    homeManager = {
      programs.umbriel.settings = {
        window_rule = [
          {
            default_maximize = false;
            default_fullscreen = false;
          }

          {
            match = {
              app_id = "steam";
              title = "^(?![Ss]team$)";
            };
            default_floating = true;
          }

          {
            match = {
              app_id = "steam";
              title = "^notificationtoasts_\\d+_desktop$";
            };
            default_position = {
              x = 10;
              y = 10;
              anchor = "bottom_right";
            };
            default_focused = false;
          }

          # Extras do pacote do Umbriel e do Noctalia.
          # { blur = true; } # blur em todas as janelas
          # {
          #   match.app_id = "^dev.noctalia.Noctalia$";
          #   default_floating = true;
          #   default_floating_size_px = { width = 1020; height = 900; };
          # }
          # {
          #   match.app_id = "^dev.noctalia.UmbrielSharePicker$";
          #   default_floating = true;
          #   default_floating_size_px = { width = 800; height = 600; };
          # }
          # {
          #   match.title = "^(Picture-in-Picture|Picture in picture)$";
          #   default_floating = true;
          #   default_position = { x = 20; y = 20; anchor = "bottom_right"; };
          # }
          # {
          #   match.app_id = "^steam_app_.*$";
          #   confine_pointer = true;
          #   vrr = "fullscreen";
          # }
        ];

        layer_rule = [
          # Blur nas superfícies do Noctalia (a regra do pacote do Umbriel).
          # {
          #   match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
          #   blur = true;
          #   blur_ignore_alpha = 0.5;
          #   blur_popups = true;
          # }
          # {
          #   match.namespace = "^noctalia-(notification|dock|panel|attached-panel|osd)$";
          #   blur_optimized = false;
          # }
        ];
      };
    };
  };
}
