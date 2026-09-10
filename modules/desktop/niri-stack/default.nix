{ den, ... }: {
  den.aspects.niri-stack = {
    includes = with den.aspects; [
      niri
      noctalia
      xdg
    ];
  };
}
