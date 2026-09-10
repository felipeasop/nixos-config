{
  den.aspects.mango = {
    description = "MangoWM: compositor Wayland de tags configurado por ~/.config/mango/config.conf.";

    # Mango, como Niri, é escolhido do lado do usuário. A fatia NixOS é
    # encaminhada aos hosts onde esse usuário existe para registrar a sessão.
    provides.to-hosts.nixos.programs.mango.enable = true;
  };
}
