{ den, ... }:
let
  components = with den.aspects; [
    # Emuladores
    azahar
    eden
    melonds

    # Compatibilidade e modding
    protonup-qt
    r2modman

    # Desempenho e monitoramento
    gamescope
    mangohud
    gamemode

    # Plataformas e launchers
    steam
    sober # Roblox
    prismlauncher # Minecraft

    # Controles
    controllers
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
