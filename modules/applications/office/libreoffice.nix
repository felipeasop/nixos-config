{
  den.aspects.libreoffice = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.libreoffice-qt-stable ];
    };
  };
}
