{
  den.aspects.steam.nixos = {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = false;
      };

      gamemode.enable = true;
    };
  };
}
