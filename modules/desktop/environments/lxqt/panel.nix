{
  den.aspects.lxqt = {
    homeManager = {
      # Gerado pelo Home Manager: o que a GUI do LXQt mudar se perde no próximo switch.
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
}
