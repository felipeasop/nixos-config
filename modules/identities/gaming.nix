{ den, ... }: {
  den.aspects.gaming = {
    includes = with den.aspects; [
      steam
      proton
      sober
      gamescope
      controllers
      mangohud
    ];
  };
}
