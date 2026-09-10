{ den, ... }:

{
  # Fix M4/M5 do Logitech M650L, completo em duas etapas:
  #
  # ETAPA 1 (hold real): botões M4/M5 disparavam só no RELEASE, não no
  # PRESS. Firmware trata os botões como gatilho de gesto (scroll
  # horizontal) e só emite o evento após descartar o gesto. logiops/logid
  # não resolve: só tem modo OnRelease, sem OnPress (PixlOne/logiops#496).
  # Fix: Solaar assume os botões via HID++ (divert-keys) e a regra abaixo
  # emite depress/release reais via uinput no press/release físico — hold
  # real, validado via libinput debug-events.
  #
  # ETAPA 2 (virar botão de mouse de verdade): mesmo com o hold correto,
  # M4/M5 não funcionavam em JOGOS (confirmado com Risk of Rain 2). Causa
  # raiz confirmada via libinput debug-events: o Solaar emite os botões
  # diverted como KEY_BACK/KEY_FORWARD num device de TECLADO virtual
  # ("solaar-keyboard"). Apps de desktop (browser etc) bindam essas teclas
  # normalmente, mas jogos esperam Mouse4/Mouse5 (BTN_SIDE/BTN_EXTRA) —
  # nunca vai funcionar com tecla, não importa o SO.
  #
  # O Solaar NÃO consegue emitir botão de mouse lateral nativamente: a
  # action MouseClick das suas regras só cobre left/middle/right
  # (confirmado na doc oficial, pwr-solaar.github.io/Solaar/rules). Não
  # existe combinação de rules.yaml que resolva isso. Fix: um daemon
  # simples (python-evdev) lê o device "solaar-keyboard" que o Solaar já
  # cria, faz grab() nele (pra não vazar como tecla pro resto do sistema)
  # e reemite KEY_BACK→BTN_SIDE, KEY_FORWARD→BTN_EXTRA num segundo device
  # uinput, esse sim visto pelo kernel/jogos como um mouse de verdade.
  #
  # Nota sobre "solaar sem GUI": não existe modo CLI-only do daemon —
  # GTK3 é dependência hard do próprio pacote pra rodar com regras ativas
  # (confirmado em pwr-solaar.github.io/Solaar/installation). `--window
  # =hide` é o único jeito suportado de rodar em background; roda o app
  # completo (GTK/D-Bus), só sem mostrar janela. Isso é o que causa o
  # bug de `solaar config` conflitando com o daemon vivo, contornado no
  # serviço de divert abaixo (stop/start temporário do daemon).
  #
  # Específico deste mouse (nome, CIDs) — separado de solaar.nix
  # (genérico) para não carregar lixo se o mouse for trocado no futuro.
  den.aspects.solaar-m650l = {
    # Dependência explícita nível 1: traz solaar automaticamente, não
    # exige que quem inclui solaar-m650l lembre de incluir solaar também.
    includes = [ den.aspects.solaar ];

    homeManager = { pkgs, ... }: {
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
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 5"; # espera o solaar detectar o mouse
          # systemd-run --user --collect roda o stop/start do daemon
          # como transação systemd totalmente separada, fora da
          # árvore/cgroup deste unit — evita qualquer propagação de
          # sinal (TERM) de volta pra este processo, que acontecia
          # mesmo com Wants em vez de Requires.
          ExecStart = "${pkgs.writeShellScript "solaar-m650l-divert" ''
            set -e
            systemd-run --user --collect --wait --quiet \
              ${pkgs.systemd}/bin/systemctl --user stop solaar.service
            sleep 2
            ${pkgs.solaar}/bin/solaar config "Signature M650 L" divert-keys 83 2
            sleep 1
            ${pkgs.solaar}/bin/solaar config "Signature M650 L" divert-keys 86 2
            sleep 1
            systemd-run --user --collect --wait --quiet \
              ${pkgs.systemd}/bin/systemctl --user start solaar.service
          ''}";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };

    # Dono-user (segue solaar): este aspect é incluído em flp.nix, então
    # a fatia `nixos` (minoritária aqui) PRECISA passar por
    # provides.to-hosts.nixos, senão fica órfã e nunca é avaliada —
    # exatamente o bug que a auditoria de 2026-07-31 (AGENTS.md) já
    # corrigiu em `solaar`, `niri` e `git`. Não repetir o erro aqui.
    provides.to-hosts.nixos =
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
            # Roda como flp: precisa ver o device solaar-keyboard, que é
            # criado no contexto da sessão gráfica do usuário (o Solaar
            # roda via systemd.user). Rodar como root não ajudaria a
            # achar o device mais rápido, só complicaria permissão de
            # leitura da sessão gráfica.
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
        '';
        users = {
          groups.input = { };
          users.flp.extraGroups = [ "input" ];
        };
      };
  };
}
