{ den, ... }: {
  den.aspects.wm = {
    includes = with den.aspects; [
      niri
      noctalia
      xdg
    ];
  };
}
