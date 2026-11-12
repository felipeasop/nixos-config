{
  den.aspects.essential = {
    nixos = {
      services.openssh = {
        enable = true;
        # Só as chaves declaradas no Nix valem; ~/.ssh/authorized_keys é ignorado.
        authorizedKeysInHomedir = false;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          KbdInteractiveAuthentication = false;
        };
      };
    };
  };
}
