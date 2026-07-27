{ inputs, ... }: {
  den.aspects.noctalia = {
    homeManager = {
      imports = [ inputs.noctalia.homeModules.default ];
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
      };

      systemd.user.services.noctalia.Unit.ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
    };
  };
}
