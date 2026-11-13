let
  theme = pkgs: {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    polarity = "dark";

    cursor = {
      name = "breeze_cursors";
      package = pkgs.kdePackages.breeze;
      size = 24;
    };

    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      };
      sansSerif = {
        name = "Inter";
        package = pkgs.inter;
      };
      sizes = {
        applications = 10;
        desktop = 10;
        terminal = 14;
      };
    };

    opacity.terminal = 0.92;
  };
in
{
  den.aspects.flp = {
    homeManager = { pkgs, ... }: {
      stylix = theme pkgs;
    };

    # GRUB, console e greeter são do sistema; o Home Manager herda o tema dele.
    provides.to-hosts = {
      nixos = { pkgs, ... }: {
        stylix = theme pkgs;
      };
    };
  };
}
