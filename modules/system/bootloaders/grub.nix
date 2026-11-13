{
  den.aspects.grub = {
    nixos = {
      stylix.targets.grub.enable = true;

      boot.loader.grub = {
        enable = true;
        devices = [ "/dev/sda" ];
        configurationLimit = 10;
        # useOSProber = true;
      };
    };
  };
}
