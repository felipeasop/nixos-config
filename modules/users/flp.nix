{ den, ... }: {
  den.aspects.flp = {
    includes = with den.aspects; [
      den._.host-aspects

      dev

      fish
      starship
      claude

      yazi
    ];
  };
}
