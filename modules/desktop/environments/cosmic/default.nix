{
  den.aspects.cosmic = {
    nixos = {
      services = {
        desktopManager.cosmic.enable = true;
        displayManager.cosmic-greeter.enable = true;
      };
    };
  };
}
