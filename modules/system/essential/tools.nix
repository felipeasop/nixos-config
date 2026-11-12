{
  den.aspects.essential = {
    nixos = { pkgs, ... }: {
      programs.htop.enable = true;

      environment.systemPackages = with pkgs; [
        psmisc
        file
        wget
        unzip
        lsof
        pciutils
        usbutils
      ];
    };
  };
}
