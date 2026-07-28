{
  stdenv,
  lib,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "sql-power-architect";
  version = "1.0.9";

  # Mantido em assets/ por enquanto (não publicado em nenhum mirror oficial
  # com hash estável). Se quiser trocar por fetchurl com hash fixo no
  # futuro, é só substituir esta linha.
  src = ../../../assets/apps/SQL-Power-Architect-generic-${version}.tar.gz;

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/architect $out/bin
    cp -r . $out/share/architect/
    mkdir -p $out/share/architect/jdbc
    makeWrapper ${jre}/bin/java $out/bin/architect \
      --set _JAVA_AWT_WM_NONREPARENTING 1 \
      --set GDK_BACKEND x11 \
      --add-flags "-Xmx600M -jar $out/share/architect/architect.jar" \
      --chdir "$out/share/architect"
  '';

  meta = with lib; {
    description = "SQL Power Architect — data modeling tool";
    homepage = "https://github.com/SQLPower/power-architect";
    license = licenses.gpl3;
    platforms = platforms.linux;
    mainProgram = "architect";
  };
}
