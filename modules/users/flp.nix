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

    homeManager.programs.git = {
      enable = true;
      settings.user = {
        name = "felipeasop";
        email = "flpasop27@gmail.com";
      };
    };
  };
}
