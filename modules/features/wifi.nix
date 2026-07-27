{
  den.aspects.wifi = {
    nixos = {
      networking.networkmanager = {
        enable = true;

        wifi = {
          # Powersave de wifi economiza bateria, mas em alguns chips causa lag/drop de conexão. Testar antes de usar
          # powersave = true;
          macAddress = "stable";
        };
      };
    };
  };
}
