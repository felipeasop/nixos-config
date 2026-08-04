{
  den.aspects.solaar = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.solaar ];

      # enableGraphical (abaixo) só instala o pacote com GUI — NÃO cria
      # nenhum serviço systemd automaticamente (confirmado no código
      # fonte do módulo NixOS hardware/logitech.nix). Sem o daemon
      # rodando em background, rules.yaml nunca é lido e o divert-keys
      # fica sem efeito (bug real: M4/M5 pararam de funcionar de vez
      # com "test", porque o divert tira o evento nativo do mouse mas
      # ninguém reemite a tecla sem o daemon ativo).
      systemd.user.services.solaar = {
        Unit = {
          Description = "Solaar Logitech device manager (daemon, sem janela)";
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.solaar}/bin/solaar --window=hide";
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };

    provides.to-hosts.nixos = {
      hardware.logitech.wireless = {
        enable = true;
        enableGraphical = true; # instala pkgs.solaar (versão com GUI); NÃO cria serviço
      };
    };
  };
}
