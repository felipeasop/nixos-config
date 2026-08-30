{ den, lib, ... }: {
  den.schema = {
    user = {
      classes = lib.mkDefault [ "homeManager" ];
      includes =
        with den.provides;
        with den.aspects;
        [
          define-user
          primary-user
          (user-shell "fish")
        ];
    };

    host.includes = with den.aspects; [
      essential
      security
      kernel
      kernel-tuning
      flatpak
    ];
  };
}
