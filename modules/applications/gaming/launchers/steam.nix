{
  den.aspects.steam = {
    nixos = {
      programs = {
        steam = {
          enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = false;
        };
      };
    };

    homeManager = {
      xdg.configFile."xdg-ninja/ignore".text = ''
        .steam
        .steampid
      '';
    };
  };
}
