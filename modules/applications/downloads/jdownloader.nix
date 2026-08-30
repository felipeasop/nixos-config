{
  den.aspects.jdownloader = {
    nixos = {
      services.flatpak.packages = [
        "org.jdownloader.JDownloader"
      ];
    };
  };
}
