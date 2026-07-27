{ stdenvNoCC, lib }:
stdenvNoCC.mkDerivation {
  pname = "exemplo-pacote";
  version = "0.0.0";
  src = ./.;
  dontBuild = true;
  installPhase = "mkdir -p $out";
  meta = {
    description = "Placeholder — apague ao adicionar o primeiro pacote real";
    license = lib.licenses.mit;
  };
}
