{ den, ... }: {
  # Fix: botões M4/M5 do Logitech M650L disparavam só no RELEASE.
  # Firmware trata os botões como gatilho de gesto (scroll horizontal)
  # e só emite o evento após descartar o gesto.
  # Fix: Solaar assume os botões via HID++ (divert) e a regra abaixo
  # emite depress/release reais via uinput no press/release físico —
  # hold real, validado via libinput debug-events no CachyOS (logid
  # parado/disabled).
  #
  # Específico deste mouse (nome, CIDs) — separado de solaar.nix
  # (genérico) para não carregar lixo se o mouse for trocado no futuro.
  den.aspects.solaar-m650l = {
    # Dependência explícita nível 1: traz solaar automaticamente,
    # não exige que quem inclui solaar-m650l lembre de incluir solaar
    # também.
    includes = [ den.aspects.solaar ];

    homeManager = { pkgs, config, ... }:
      {
        # Dependência explícita nível 2 (rede de segurança): se por
        # algum motivo o merge de `includes` acima não colocar o
        # pacote solaar em home.packages (ex.: reorganização futura
        # do repo, bug no Den, aspect incluído fora do fluxo normal),
        # o build FALHA aqui com mensagem clara, em vez de instalar o
        # rules.yaml/serviço sem o daemon que os usa.
        assertions = [
          {
            assertion = builtins.elem pkgs.solaar config.home.packages;
            message = ''
              solaar-m650l requer o pacote `solaar` em home.packages,
              mas ele não foi encontrado. Este aspect depende do
              aspect `solaar` (veja apps/peripherals/solaar.nix) —
              confirme que `includes = [ den.aspects.solaar ]` está
              presente em solaar-m650l.nix e que nada removeu o
              aspect solaar do merge final.
            '';
          }
        ];

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

        systemd.user.services.solaar-m650l-divert = {
          Unit = {
            Description = "Aplica divert-keys (fix hold M4/M5) no Logitech M650L";
            After = [ "graphical-session.target" ];
          };
          Service = {
            Type = "oneshot";
            ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
            ExecStart = [
              "${pkgs.solaar}/bin/solaar config \"Signature M650 L\" divert-keys 83 2"
              "${pkgs.solaar}/bin/solaar config \"Signature M650 L\" divert-keys 86 2"
            ];
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
  };
}
