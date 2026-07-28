_: {
  den.aspects.security = {
    nixos = {
      security.sudo.enable = false;
      security.sudo-rs = {
        enable = true;
        wheelNeedsPassword = true;
      };
    };
  };
}
