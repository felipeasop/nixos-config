{
  den.aspects.noctalia = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.ddcutil ];
      hardware.i2c.enable = true;

      users = {
        groups.i2c = { };
        users.flp.extraGroups = [ "i2c" ];
      };
    };
  };
}
