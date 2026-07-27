{
  # Fix: botões laterais do mouse Logitech M650 só disparavam a ação
  # no RELEASE, não no PRESS. Causa: o M650 tem um gesto oculto
  # (segurar botão lateral + rolar = scroll horizontal) e o driver
  # espera pra ver se esse gesto vai acontecer antes de emitir o
  # clique — daí o delay. Desabilitando scroll horizontal via
  # libinput, o clique passa a disparar imediatamente.
  den.aspects.essential = {
    nixos = {
      services.libinput.mouse.horizontalScrolling = false;
    };
  };
}
