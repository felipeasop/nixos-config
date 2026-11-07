{
  den.aspects.libreoffice = {
    homeManager = { pkgs, ... }: {
      programs.libreoffice = {
        enable = true;
        package = pkgs.libreoffice-qt-stable;
      };
    };
  };
}
