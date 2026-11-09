# gnome-keyring para niri e KWallet para Plasma
{
  den.aspects.security = {
    nixos = {
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.sddm.enableGnomeKeyring = true;
    };

    provides.to-users = {
      homeManager = {
        services.gnome-keyring.enable = true;
      };
    };
  };
}
