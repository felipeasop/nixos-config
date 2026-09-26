{ lib, ... }:
{
  den.aspects.eden = {
    homeManager =
      { pkgs, ... }:
      let
        edenWithGameMode = pkgs.symlinkJoin {
          name = "${pkgs.eden.name}-with-gamemode";
          paths = [ pkgs.eden ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram "$out/bin/eden" \
              --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ (lib.getLib pkgs.gamemode) ]}
          '';
          meta.mainProgram = "eden";
        };
      in
      {
        home.packages = [ edenWithGameMode ];
      };
  };
}
