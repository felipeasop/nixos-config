_: {
  den.aspects.security = {
    nixos = {
      security = {
        sudo.enable = false;
        sudo-rs = {
          enable = true;
          wheelNeedsPassword = true;
        };
      };
    };
  };
}
