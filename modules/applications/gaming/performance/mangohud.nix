{
  den.aspects.mangohud = {
    homeManager = {
      stylix.targets.mangohud.enable = true;

      programs.mangohud = {
        enable = true;
        settings = {
          fps_limit = 0;
          cpu_temp = true;
          gpu_temp = true;
          ram = true;
          vram = true;
        };
      };
    };
  };
}
