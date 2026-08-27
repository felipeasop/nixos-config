{ den, ... }: {
  den.aspects.desktop-stack = {
    includes = with den.aspects; [
      niri
      noctalia
      xdg
    ];
  };
}
