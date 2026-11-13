{
  den.aspects.foot = {
    homeManager = { lib, ... }: {
      stylix.targets.foot.enable = true;

      programs.foot.enable = true;

      xdg.terminal-exec = {
        enable = true;
        settings.default = lib.mkAfter [ "foot.desktop" ];
      };
    };
  };
}
