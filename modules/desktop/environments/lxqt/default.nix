_: {
  den.aspects.lxqt = {
    nixos = { lib, ... }: {
      # O alvo Qt do Stylix só tema apps Qt na plataforma qtct, não na lxqt.
      stylix.targets.qt.platform = lib.mkForce "qtct";

      # LXQt/LightDM ainda usam o namespace xserver.* (não migraram como KDE/Cosmic).
      services = {
        xserver.displayManager.lightdm.enable = true;
        xserver.desktopManager.lxqt.enable = true;
        printing.enable = true;
      };
      programs.nm-applet.enable = true;
    };

    # Auto-roteado pro usuário
    provides.to-users.homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.xcape ];

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

        # Enxuto: só o essencial (terminal/browser/arquivos/lock/workspaces/
        # mídia/energia), espelhando os binds que já existem no niri. Fora
        # disso Openbox já cobre Alt+Tab nativamente.
        "lxqt/globalkeyshortcuts.conf".text = ''
          [General]
          AllowGrabBaseKeypad=true
          AllowGrabBaseSpecial=false
          AllowGrabLocks=false
          AllowGrabMiscKeypad=true
          AllowGrabMiscSpecial=true
          MultipleActionsBehaviour=first
          WindowSize=@Invalid()

          [Meta%2BReturn.1]
          Comment=Terminal (Alacritty)
          Enabled=true
          Exec=alacritty

          [Meta%2BB.2]
          Comment=Browser (Firefox)
          Enabled=true
          Exec=firefox

          [Meta%2BE.3]
          Comment=File manager (PCManFM-Qt)
          Enabled=true
          Exec=pcmanfm-qt

          [Meta%2BAlt%2BL.4]
          Comment=Lock screen
          Enabled=true
          Exec=xdg-screensaver, lock

          [Alt%2BF2.5]
          Comment=App launcher (runner)
          Enabled=true
          path=/runner/show_hide_dialog

          [XF86LaunchA.6]
          Comment=App launcher (Super sozinho, via xcape)
          Enabled=true
          path=/runner/show_hide_dialog

          [Meta%2B1.7]
          Comment=Workspace 1
          Enabled=true
          path=/panel/desktopswitch/desktop_1

          [Meta%2B2.8]
          Comment=Workspace 2
          Enabled=true
          path=/panel/desktopswitch/desktop_2

          [Meta%2B3.9]
          Comment=Workspace 3
          Enabled=true
          path=/panel/desktopswitch/desktop_3

          [Meta%2B4.10]
          Comment=Workspace 4
          Enabled=true
          path=/panel/desktopswitch/desktop_4

          [Print.11]
          Comment=Screenshot
          Enabled=true
          Exec=screengrab, -f

          [XF86AudioLowerVolume.12]
          Comment=Decrease sound volume
          Enabled=true
          path=/panel/volume/down

          [XF86AudioMute.13]
          Comment=Mute/unmute sound volume
          Enabled=true
          path=/panel/volume/mute

          [XF86AudioRaiseVolume.14]
          Comment=Increase sound volume
          Enabled=true
          path=/panel/volume/up

          [XF86MonBrightnessDown.15]
          Comment=☀ ↓
          Enabled=true
          Exec=lxqt-config-brightness, -d

          [XF86MonBrightnessUp.16]
          Comment=☀ ↑
          Enabled=true
          Exec=lxqt-config-brightness, -i

          [XF86PowerOff.17]
          Comment=Power off key action
          Enabled=true
          path=/powermanager/keypoweroff

          [XF86Sleep.18]
          Comment=Hibernate key action
          Enabled=true
          path=/powermanager/keyhibernate

          [XF86Suspend.19]
          Comment=Suspend key action
          Enabled=true
          path=/powermanager/keysuspend
        '';
      };

      # xcape finge um tap de Super_L como XF86LaunchA (F13 falha: sem keycode no layout br-abnt2).
      systemd.user.services.xcape-super = {
        Unit.Description = "Super sozinho (tap) abre o runner do LXQt, via xcape";
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          ExecStart = "${pkgs.xcape}/bin/xcape -e 'Super_L=XF86LaunchA'";
          Restart = "on-failure";
        };
      };
    };
  };
}
