{
  den.aspects.graphical = {
    nixos = { pkgs, ... }: {
      services.xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];
      };
      # services.printing.enable = true;
    };
  };
}
