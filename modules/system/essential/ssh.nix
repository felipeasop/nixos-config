{
  den.aspects.essential = {
    nixos = {
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          KbdInteractiveAuthentication = false;
        };
      };
    };
  };
}
