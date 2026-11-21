{
  den.aspects.onlyoffice = {
    homeManager = { config, pkgs, ... }: {
      programs.onlyoffice = {
        enable = true;
        # O FHS do pacote só expõe estas fontes (e as de ~/.local/share/fonts).
        package = pkgs.onlyoffice-desktopeditors.override {
          extraFontPackages = with config.stylix.fonts; [
            serif.package
            sansSerif.package
            monospace.package
            emoji.package
            pkgs.liberation_ttf
          ];
        };
      };
    };
  };
}
