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
            - KeyPress: [XF86_Back, depress]
          ---
          - Rule:
            - Key: [Back Button, released]
            - KeyPress: [XF86_Back, release]
          ---
          - Rule:
            - Key: [Forward Button, pressed]
            - KeyPress: [XF86_Forward, depress]
          ---
          - Rule:
            - Key: [Forward Button, released]
            - KeyPress: [XF86_Forward, release]
          ...
        '';

        # config.yaml (guarda divert-keys) é escrito pelo próprio Solaar
        # em runtime, identificado por serial do mouse — não dá pra
        # declarar via xdg.configFile sem risco de conflito/perda de
        # estado (bateria etc). Versiona-se o COMANDO, idempotente,
        # reaplicado a cada login em vez de passo manual único.
        #
        # `solaar config` NÃO precisa de GTK3 pra funcionar (confirmado
        # na doc oficial: só usa Gtk pra checar se a GUI já tá rodando
        # e notificá-la) — só que, com o daemon rodando ao mesmo tempo,
        # duas chamadas consecutivas de `solaar config` já quebraram
        # (Back aplicado ok, Forward falhou) por bug de marshaling
        # D-Bus na versão em uso. Contorno: para o daemon antes,
        # aplica os dois divert-keys sem ele vivo, religa depois.
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
            ExecStartPre = "${pkgs.coreutils}/bin/sleep 5"; # espera o solaar detectar o mouse
            # systemd-run --user --collect roda o stop/start do daemon
            # como transação systemd totalmente separada, fora da
            # árvore/cgroup deste unit — evita qualquer propagação de
            # sinal (TERM) de volta pra este processo, que acontecia
            # mesmo com Wants em vez de Requires.
            ExecStart = "${pkgs.writeShellScript "solaar-m650l-divert" ''
              set -e

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

    # O dispositivo pertence ao host. Sua configuração NixOS é consumida
    # diretamente; a parte Home Manager acima é encaminhada pelo host ao
    # usuário integrado por `provides.to-users`.
    nixos =
      { pkgs, ... }:
      let
        remapScript = pkgs.writeText "m650l-mouse-remap.py" (builtins.readFile ./m650l-mouse-remap.py);
        pythonEnv = pkgs.python3.withPackages (ps: [ ps.evdev ]);
      in
      {
        # Precisa rodar como serviço de SISTEMA (não user), porque
        # /dev/uinput e a leitura exclusiva (grab) de /dev/input/eventX
        # normalmente exigem acesso que o systemd.user não garante por
        # padrão sem regra udev extra. Serviço de sistema + usuário fixo
        # evita esse problema de permissão.
        systemd.services.m650l-mouse-remap = {
          description = "Traduz KEY_BACK/KEY_FORWARD (solaar-keyboard) em BTN_SIDE/BTN_EXTRA (mouse virtual) — fix M4/M5 em jogos";
          after = [ "graphical-session.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "simple";
            User = "flp";
            SupplementaryGroups = [ "input" ];
            ExecStart = "${pythonEnv}/bin/python3 ${remapScript}";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };

        # Garante que o usuário flp tem acesso a /dev/uinput (criar o
        # device de mouse virtual) e /dev/input/event* (grab do
        # solaar-keyboard) sem precisar rodar como root.
        services.udev.extraRules = ''
          KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", MODE="0660", GROUP="input", TAG+="uaccess"
        '';
        users = {
          groups.input = { };
          users.flp.extraGroups = [ "input" ];
        };
      };
  };
}
