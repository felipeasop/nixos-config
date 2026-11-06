{
  den.aspects.essential = {
    nixos = { pkgs, ... }: {
      services.xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];
      };
      # services.printing.enable = true;
    };
  };
}
