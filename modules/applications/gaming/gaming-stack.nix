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
  den.aspects.gaming-stack = {
    includes = components;
  };
}
