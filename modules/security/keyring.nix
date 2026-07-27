# gnome-keyring guarda senhas de forma persistente entre reboots.
# Necessário sobretudo na sessão niri
# KDE usa o KWallet próprio dele via plasma6.nix
# Os dois podem coexistir, se aparecer 2 prompts de unlock no primeiro login
# se logar nas duas sessões é normal
{
  den.aspects.security = {
    nixos = {
      services.gnome.gnome-keyring.enable = true;
      security.pam.services.sddm.enableGnomeKeyring = true;
    };

    homeManager.services.gnome-keyring.enable = true;
  };
}
