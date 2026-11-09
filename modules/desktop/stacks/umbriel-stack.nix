{ den, ... }: {
  den.aspects.umbriel-stack = {
    includes = with den.aspects; [
      umbriel
      noctalia
      xdg-portals
      dolphin
    ];
  };
}
