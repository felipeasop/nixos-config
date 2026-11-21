{
  den.aspects.printing = {
    nixos = {
      services = {
        # A descoberta na rede vem do Avahi do essential (browsed liga junto).
        printing = {
          enable = true;
          # drivers = with pkgs; [
          #   hplip # HP
          #   brlaser # Brother laser
          #   splix # Samsung, Xerox
          #   gutenprint # Epson e outras jato de tinta
          # ];
        };
        ipp-usb.enable = true;
      };
    };
  };
}
