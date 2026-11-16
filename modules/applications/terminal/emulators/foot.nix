{
  den.aspects.foot = {
    homeManager = { lib, pkgs, ... }: {
      stylix.targets.foot.enable = true;

      programs.foot = {
        enable = true;
        settings = {
          main.pad = "6x6";
          scrollback.lines = 10000;
          cursor.blink = true;
          mouse.hide-when-typing = true;
          key-bindings.pipe-scrollback = "[${lib.getExe' pkgs.wl-clipboard "wl-copy"}] Control+Shift+a";
        };
      };

      xdg.terminal-exec = {
        enable = true;
        settings.default = lib.mkAfter [ "foot.desktop" ];
      };
    };
  };
}
