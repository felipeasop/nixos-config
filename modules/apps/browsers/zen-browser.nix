{ inputs, ... }: {
  den.aspects.zen-browser = {
    homeManager = {
      imports = [ inputs.zen-browser.homeModules.beta ];
      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;
      };
    };
  };
}
