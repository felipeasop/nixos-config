{
  den.aspects.lxqt = {
    nixos = { lib, ... }: {
      stylix.targets = {
        lightdm.enable = true;
        # O alvo Qt do Stylix só tema apps Qt na plataforma qtct, não na lxqt.
        qt.platform = lib.mkForce "qtct";
      };

      # LXQt/LightDM ainda usam o namespace xserver.* (não migraram como KDE/Cosmic).
      services = {
        xserver = {
          displayManager.lightdm.enable = true;
          desktopManager.lxqt.enable = true;
        };
        printing.enable = true;
      };
      programs.nm-applet.enable = true;
    };
  };
}
