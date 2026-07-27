{
  den.aspects.grub = {
    nixos = {
      boot.loader.grub = {
        enable = true;
        devices = [ "/dev/sda" ];
        configurationLimit = 10;
        # useOSProber = true;
      };
    };
  };
}
