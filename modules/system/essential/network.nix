{
  den.aspects.essential = {
    nixos = {
      networking.networkmanager.enable = true;

      # mDNS: cada host se anuncia e acha os outros como <host>.local em
      # qualquer rede local, sem IP fixo.
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          addresses = true;
        };
      };
    };
  };
}
