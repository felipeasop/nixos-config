{ den, ... }:

{
  den.aspects.solaar-m650l = {
    includes = [ den.aspects.solaar ];

    homeManager =
      { lib, pkgs, ... }:
      let
        notifyTypelibPath = lib.makeSearchPath "lib/girepository-1.0" [ pkgs.libnotify ];
        notifyLibraryPath = lib.makeLibraryPath [ pkgs.libnotify ];
      in
      {
        xdg.configFile."solaar/rules.yaml".text = ''
          %YAML 1.3
          ---
          - Rule:
            - Key: [Back Button, pressed]
            - MouseClick: [back, depress]
          ---
          - Rule:
            - Key: [Back Button, released]
            - MouseClick: [back, release]
          ---
          - Rule:
            - Key: [Forward Button, pressed]
            - MouseClick: [forward, depress]
          ---
          - Rule:
            - Key: [Forward Button, released]
            - MouseClick: [forward, release]
          ...
        '';

        # O Solaar reaplica o divert-keys salvo no config.yaml a cada conexão; isto só o
        # grava na primeira vez, com o daemon parado, pois chamadas com ele ativo falhavam via D-Bus.
        systemd.user.services.solaar-m650l-divert = {
          Unit = {
            Description = "Aplica divert-keys (fix hold M4/M5) no Logitech M650L";
            After = [ "solaar.service" ];
            Wants = [ "solaar.service" ];
          };
          Service = {
            Type = "oneshot";
            RemainAfterExit = true;
            Restart = "on-failure";
            RestartSec = 15;
            ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
            ExecStart = "${pkgs.writeShellScript "solaar-m650l-divert" ''
              set -e

              config="''${XDG_CONFIG_HOME:-$HOME/.config}/solaar/config.yaml"
              if ${pkgs.gnugrep}/bin/grep -qE 'divert-keys: \{[^}]*83: 1[^}]*86: 1' "$config" 2>/dev/null; then
                exit 0
              fi

              export GI_TYPELIB_PATH=${lib.escapeShellArg notifyTypelibPath}
              export LD_LIBRARY_PATH=${lib.escapeShellArg notifyLibraryPath}

              receiver_accessible() {
                for uevent in /sys/class/hidraw/hidraw*/device/uevent; do
                  [[ -e "$uevent" ]] || continue
                  [[ "$(<"$uevent")" == *"HID_ID=0003:0000046D:"* ]] || continue

                  node="''${uevent#/sys/class/hidraw/}"
                  node="/dev/''${node%%/*}"
                  [[ -r "$node" && -w "$node" ]] && return 0
                done
                return 1
              }

              for _attempt in {1..30}; do
                receiver_accessible && break
                ${pkgs.coreutils}/bin/sleep 2
              done

              if ! receiver_accessible; then
                echo "Receptor Logitech sem acesso; reconecte-o para reaplicar as regras udev." >&2
                exit 1
              fi

              # systemd-run isola o stop/start do cgroup deste unit, evitando receber o TERM do solaar.
              restart_solaar() {
                ${pkgs.systemd}/bin/systemd-run --user --collect --wait --quiet \
                  ${pkgs.systemd}/bin/systemctl --user start solaar.service || true
              }

              trap restart_solaar EXIT
              ${pkgs.systemd}/bin/systemd-run --user --collect --wait --quiet \
                ${pkgs.systemd}/bin/systemctl --user stop solaar.service
              ${pkgs.coreutils}/bin/sleep 2
              ${pkgs.solaar}/bin/solaar config "Signature M650 L" divert-keys 83 2
              ${pkgs.coreutils}/bin/sleep 1
              ${pkgs.solaar}/bin/solaar config "Signature M650 L" divert-keys 86 2
              ${pkgs.coreutils}/bin/sleep 1
              restart_solaar
              trap - EXIT
            ''}";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
  };
}
