# O que todo host, usuário e home recebe por padrão (ver AGENTS.md).
{ den, lib, ... }: {
  den = {
    default.includes = with den.aspects; [
      den.batteries.define-user
      essential
      git
      xdg-base-dirs
    ];

    schema = {
      home.includes = with den.aspects; [
        stylix
        {
          homeManager = {
            targets.genericLinux.enable = true;
          };
        }
      ];

      host.includes = with den.aspects; [
        den.batteries.hostname
        den.batteries.user-aspects
        audio
        graphical
        default-browser
        unrar
        qalculate
        multimedia
        security
        bootloader
        kernel
        kernel-tuning
        gpu
        flatpak
        ssh
      ];

      user = {
        classes = lib.mkDefault [ "homeManager" ];
        includes = [ den.batteries.host-aspects ];
      };
    };
  };
}
