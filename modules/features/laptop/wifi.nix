{
  den.aspects.wifi = {
    nixos = {
      networking.networkmanager = {
        enable = true;

        wifi = {
          macAddress = "stable";
        };
      };
    };
  };
}
