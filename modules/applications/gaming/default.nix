{ den, ... }:
let
  components = with den.aspects; [
    # Emuladores
    azahar
    eden

    # Compatibilidade, desempenho e controles
    proton
    gamescope
    controllers
    mangohud

    # Plataformas e launchers
    steam
    sober # Roblox
    prismlauncher # Minecraft

    # Mods
    r2modman
  ];
in
{
  # Stack dona-user: Home Manager é resolvido diretamente no usuário, enquanto
  # as fatias NixOS dos mesmos componentes são entregues ao host relacionado.
  den.aspects.gaming-stack = {
    includes = components;
    provides.to-hosts.includes = components;
  };
}
