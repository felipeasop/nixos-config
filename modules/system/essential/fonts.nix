{
  den.aspects.essential.nixos = { pkgs, ... }: {
    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        inter
      ];
      fontconfig.defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Inter" ];
      };
    };
  };
}
