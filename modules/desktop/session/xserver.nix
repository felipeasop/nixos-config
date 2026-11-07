{ den, ... }: {
  den.aspects.graphical = {
    includes = [ den.aspects.stylix ];

    nixos = { pkgs, ... }: {
      services.xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];
      };
      # services.printing.enable = true;
    };
  };
}
