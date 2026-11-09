{
  den.aspects.niri = {
    homeManager = { config, ... }: {
      programs.niri.settings = {
        prefer-no-csd = true;
        screenshot-path = null;

        cursor = {
          theme = config.stylix.cursor.name;
          inherit (config.stylix.cursor) size;
        };
      };
    };
  };
}
