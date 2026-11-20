{
  den.aspects.solaar = {
    nixos = {
      programs.solaar = {
        enable = true;
        userService = {
          enable = true;
          window = "hide";
        };
      };
    };
  };
}
