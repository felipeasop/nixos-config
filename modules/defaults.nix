# O que todo host, usuário e home recebe por padrão (ver AGENTS.md).
{ den, lib, ... }: {
  den = {
    default.includes = with den.aspects; [
      den.batteries.define-user
      essential
      git
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
        den.batteries.user-aspects
        audio
        graphical
        unrar
        multimedia
        security
        kernel
        kernel-tuning
        flatpak
      ];

      user = {
        classes = lib.mkDefault [ "homeManager" ];
        includes = [ den.batteries.host-aspects ];
      };
    };
  };
}
