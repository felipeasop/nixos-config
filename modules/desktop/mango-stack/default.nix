{ den, ... }: {
  den.aspects.mango-stack = {
    includes = with den.aspects; [
      mango
      noctalia
      xdg
    ];
  };
}
