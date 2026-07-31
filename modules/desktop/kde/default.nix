{
  den.aspects.kde = {
    nixos = {
      services = {
        displayManager.sddm.enable = true;
        desktopManager.plasma6.enable = true;
      };
    };
  };
}
