{
  den.aspects.noctalia = {
    homeManager = {
      programs.noctalia.settings = {
        plugins = {
          auto_update = "all";
          enabled = [ ]; # nomes de plugins ativos, ex: [ "zen-browser" ]
          source = [
            {
              name = "official";
              kind = "git";
              location = "https://github.com/noctalia-dev/official-plugins";
              enabled = true;
            }
            {
              name = "community";
              kind = "git";
              location = "https://github.com/noctalia-dev/community-plugins";
              enabled = true;
            }
          ];
        };
      };
    };
  };
}
