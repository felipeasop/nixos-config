{ self, ... }: {
  den.aspects.sql-power-architect = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [
        (pkgs.stdenv.mkDerivation rec {
          pname = "sql-power-architect";
          version = "1.0.9";

          src = "${self}/assets/apps/SQL-Power-Architect-generic-1.0.9.tar.gz";

          nativeBuildInputs = [ pkgs.makeWrapper ];
          dontBuild = true;

          installPhase = ''
            mkdir -p $out/share/architect $out/bin
            cp -r . $out/share/architect/
            mkdir -p $out/share/architect/jdbc
            makeWrapper ${pkgs.jre}/bin/java $out/bin/architect \
            --set _JAVA_AWT_WM_NONREPARENTING 1 \
            --set GDK_BACKEND x11 \
            --add-flags "-Xmx600M -jar $out/share/architect/architect.jar" \
            --chdir "$out/share/architect"
          '';

          meta = with pkgs.lib; {
            description = "SQL Power Architect — data modeling tool";
            homepage = "https://github.com/SQLPower/power-architect";
            license = licenses.gpl3;
            platforms = platforms.linux;
            mainProgram = "architect";
          };
        })
      ];
    };
  };
}
