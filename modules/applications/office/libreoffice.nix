{
  # -fresh (mais recente, mais features) em vez de -still (estável/LTS).
  # -qt6: você usa KDE Plasma além de Niri (confirmado:
  # modules/desktop/kde/default.nix existe e é incluído em desktop). Sem
  # essa variante falta a barra de menu principal e outras integrações
  # de tema/ícone (NixOS Wiki). É qt6, não qt sozinho — qt5/"qt" puro é
  # a variante legada para Plasma 5, e o KDE atual é Plasma 6.
  den.aspects.libreoffice = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.libreoffice-qt6-fresh ];
    };
  };
}
