{
  den.aspects.lxqt = {
    provides.to-users = {
      homeManager = {
        # Declarado aqui = imutável; editar pela GUI do LXQt não persiste.
        xdg.configFile = {
          "lxqt/panel.conf".text = ''
            [General]
            __userfile__=true
            theme=KDE-Plasma
            plugins=mainmenu, desktopswitch, taskbar, mount, tray, volume, worldclock

            [mainmenu]
            alignment=Left

            [desktopswitch]
            alignment=Left

            [mount]
            alignment=Right

            [taskbar]
            alignment=Left

            [tray]
            alignment=Right

            [volume]
            alignment=Right

            [worldclock]
            alignment=Right
          '';
        };
      };
    };
  };
}
