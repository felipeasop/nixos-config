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
        multimedia
        security
        kernel
        kernel-tuning
        flatpak
      ];

      # Sem uso com um usuário só: o comum a todos fica em den.default e o resto
      # no aspect do usuário. Com mais usuários, entra aqui o que todo usuário
      # recebe e host e home standalone não (ex.: grupos, shell padrão).
      # user.includes = with den.aspects; [ ];
    };
  };
}
