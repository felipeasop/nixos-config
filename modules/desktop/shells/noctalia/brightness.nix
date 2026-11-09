{
  den.aspects.noctalia = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.ddcutil ];
      hardware.i2c.enable = true;
    };

    provides.to-users.user.extraGroups = [ "i2c" ];

    homeManager = {
      programs.noctalia.settings = {
        brightness = {
          enable_ddcutil = true;
          sync_all_monitors = false;
          minimum_brightness = 0.0;
          # ignore_mmids = [ ];  # IDs de monitores a ignorar
        };
      };
    };
  };
}
