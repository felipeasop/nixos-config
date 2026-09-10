{
  den.aspects.niri = {
    homeManager =
      { pkgs, ... }:
      let
        moveWindowToNewWorkspace = pkgs.writeShellApplication {
          name = "niri-move-window-to-new-workspace";
          runtimeInputs = with pkgs; [
            jq
            niri
            util-linux
          ];
          text = ''
            set -euo pipefail

            direction="''${1:-}"
            case "$direction" in
              up | down) ;;
              *)
                printf 'Uso: %s {up|down}\n' "$0" >&2
                exit 2
                ;;
            esac

            exec 9>"$XDG_RUNTIME_DIR/niri-move-window-to-new-workspace.lock"
            flock 9

            if ! focused_window=$(niri msg -j focused-window | jq -cer '.'); then
              printf 'Não há uma janela focada para mover.\n' >&2
              exit 1
            fi

            window_id=$(jq -r '.id' <<<"$focused_window")
            workspace_id=$(jq -r '.workspace_id' <<<"$focused_window")

            workspaces=$(niri msg -j workspaces)
            current_workspace=$(
              jq -cer --argjson workspace_id "$workspace_id" \
                '.[] | select(.id == $workspace_id)' \
                <<<"$workspaces"
            )
            current_index=$(jq -r '.idx' <<<"$current_workspace")
            current_output=$(jq -r '.output' <<<"$current_workspace")
            current_name=$(jq -r '.name // empty' <<<"$current_workspace")

            windows=$(niri msg -j windows)
            window_count=$(
              jq -er --argjson workspace_id "$workspace_id" \
                '[.[] | select(.workspace_id == $workspace_id)] | length' \
                <<<"$windows"
            )

            # Se esta for a única janela de um workspace dinâmico, extraí-la
            # faria o workspace vazio desaparecer. Mover o próprio workspace
            # dá o resultado visual esperado com uma única ação. Workspaces
            # nomeados persistem vazios e seguem pelo fluxo normal abaixo.
            if [[ "$window_count" -eq 1 && -z "$current_name" ]]; then
              if [[ "$direction" == "up" ]]; then
                niri msg action move-workspace-up
              else
                niri msg action move-workspace-down
              fi
              exit
            fi

            last_index=$(
              jq -er --arg output "$current_output" \
                '[.[] | select(.output == $output) | .idx] | max' \
                <<<"$workspaces"
            )

            if [[ "$direction" == "up" ]]; then
              target_index=$current_index
            else
              target_index=$((current_index + 1))
            fi

            # O Niri mantém um workspace vazio no fim de cada monitor. A janela
            # focada é enviada para ele e o foco acompanha a operação; depois,
            # esse workspace é reposicionado junto do workspace de origem.
            niri msg action move-window-to-workspace \
              --window-id "$window_id" \
              --focus true \
              "$last_index"

            niri msg action move-workspace-to-index "$target_index"
          '';
        };

        moveToNewWorkspace = direction: {
          repeat = false;
          action.spawn = [
            "${moveWindowToNewWorkspace}/bin/niri-move-window-to-new-workspace"
            direction
          ];
        };
      in
      {
        home.packages = [ moveWindowToNewWorkspace ];

        programs.niri.settings.binds = {
          "Mod+Ctrl+Alt+J" = (moveToNewWorkspace "down") // {
            hotkey-overlay.title = "Move Window to New Workspace Down";
          };
          "Mod+Ctrl+Alt+K" = (moveToNewWorkspace "up") // {
            hotkey-overlay.title = "Move Window to New Workspace Up";
          };

          "Mod+Ctrl+Alt+Down" = moveToNewWorkspace "down";
          "Mod+Ctrl+Alt+Up" = moveToNewWorkspace "up";

          "Mod+Ctrl+Alt+WheelScrollDown" = {
            cooldown-ms = 500;
            action.spawn = [
              "${moveWindowToNewWorkspace}/bin/niri-move-window-to-new-workspace"
              "down"
            ];
          };
          "Mod+Ctrl+Alt+WheelScrollUp" = {
            cooldown-ms = 500;
            action.spawn = [
              "${moveWindowToNewWorkspace}/bin/niri-move-window-to-new-workspace"
              "up"
            ];
          };
        };
      };
  };
}
