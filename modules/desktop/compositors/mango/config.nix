{
  den.aspects.mango.homeManager =
    { pkgs, ... }:
    let
      sessionReady = pkgs.writeShellApplication {
        name = "mango-session-ready";
        runtimeInputs = [
          pkgs.dbus
          pkgs.systemd
        ];
        text = ''
          dbus-update-activation-environment --systemd \
            WAYLAND_DISPLAY \
            XDG_CURRENT_DESKTOP \
            XDG_SESSION_TYPE \
            MANGO_INSTANCE_SIGNATURE

          systemctl --user restart noctalia.service
        '';
      };

      screenshot = pkgs.writeShellApplication {
        name = "mango-screenshot";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.grim
          pkgs.jq
          pkgs.libnotify
          pkgs.mango
          pkgs.slurp
          pkgs.wl-clipboard
          pkgs.xdg-user-dirs
        ];
        text = ''
          mode="''${1:-region}"
          pictures_dir="$(xdg-user-dir PICTURES 2>/dev/null || true)"
          if [[ -z "$pictures_dir" ]]; then
            pictures_dir="$HOME/Pictures"
          fi

          output_dir="$pictures_dir/Screenshots"
          mkdir -p "$output_dir"
          output="$output_dir/$(date +%Y-%m-%d_%H-%M-%S).png"

          case "$mode" in
            region)
              geometry="$(slurp -d)"
              [[ -n "$geometry" ]] || exit 0
              grim -g "$geometry" "$output"
              ;;
            window)
              geometry="$(mmsg get focusing-client | jq -er '
                select(.x != null and .y != null and .width != null and .height != null)
                | "\(.x),\(.y) \(.width)x\(.height)"
              ')"
              grim -g "$geometry" "$output"
              ;;
            screen)
              grim "$output"
              ;;
            *)
              printf 'Uso: %s {region|window|screen}\n' "$0" >&2
              exit 2
              ;;
          esac

          wl-copy --type image/png < "$output"
          notify-send "Captura de tela" "Salva em $output"
        '';
      };
    in
    {
      home.packages = [
        sessionReady
        screenshot
      ];

      # O Mango resolve os `source` relativamente a este diretório; instalar a
      # árvore inteira garante que todos os fragmentos estejam disponíveis.
      xdg.configFile."mango" = {
        source = ./config;
        recursive = true;
      };
    };
}
