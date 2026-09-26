{ den, ... }: {
  den.schema = {
    user = {
      includes =
        with den.provides;
        with den.aspects;
        [
          define-user
          primary-user
          (user-shell "fish")
        ];
    };

    home.includes =
      with den.provides;
      with den.aspects;
      [
        define-user
        essential
        (user-shell "fish")
      ];

    host.includes = with den.aspects; [
      essential
      unrar
      security
      kernel
      kernel-tuning
      flatpak
    ];
  };
}
