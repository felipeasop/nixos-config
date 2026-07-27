{ inputs, self, ... }: {
  den.aspects.astah = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [
        (pkgs.stdenv.mkDerivation rec {
          pname = "astah-uml";
          version = "12.0.0";

          src = "${self}/assets/apps/astah-uml-12.0.0.deb";

          nativeBuildInputs = with pkgs; [
            dpkg
            makeWrapper
          ];

          unpackPhase = ''
            dpkg-deb -x $src .
          '';

          installPhase = ''
            mkdir -p $out/share/astah_uml $out/bin $out/share/applications $out/share/pixmaps
            cp -r usr/lib/astah_uml/* $out/share/astah_uml/
            cp usr/share/pixmaps/astah_uml.png $out/share/pixmaps/
            cp usr/share/applications/astah_uml.desktop $out/share/applications/
            makeWrapper ${pkgs.jre}/bin/java $out/bin/astah-uml \
                --set _JAVA_AWT_WM_NONREPARENTING 1 \
                --set GDK_BACKEND x11 \
                --set QT_QPA_PLATFORM xcb \
                --add-flags "-Xms16m -Xmx1024m -Djava.library.path=$out/share/astah_uml/lib/rlm -splash:$out/share/astah_uml/astah_splash_uml.png -jar $out/share/astah_uml/astah-uml.jar"
          '';

          meta = with pkgs.lib; {
            description = "UML modeling tool";
            homepage = "https://astah.net";
            license = licenses.unfree;
            platforms = platforms.linux;
            mainProgram = "astah-uml";
          };
        })
      ];
    };
  };
}
