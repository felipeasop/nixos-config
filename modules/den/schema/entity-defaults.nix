{ den, ... }: {
  den.schema = {
    user.includes =
      with den.provides;
      with den.aspects;
      [
        define-user
        primary-user
        (user-shell "fish")
      ];

    home.includes =
      with den.provides;
      with den.aspects;
      [
        define-user
        essential
        git
        (user-shell "fish")
      ];

    host.includes = with den.aspects; [
      essential
      audio
      graphical
      git
      unrar
      security
      kernel
      kernel-tuning
      flatpak
    ];
  };
}
