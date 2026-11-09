# O que todo host, usuário e home recebe por padrão (ver AGENTS.md).
{ den, ... }: {
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
        audio
        graphical
        admin-tools
        unrar
        security
        kernel
        kernel-tuning
        flatpak
      ];
    };
  };
}
