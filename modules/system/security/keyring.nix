# gnome-keyring em todo host; o KWallet do Plasma vem do aspect kde.
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
