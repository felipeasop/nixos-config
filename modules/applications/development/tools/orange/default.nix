{
  den.aspects.orange = {
    homeManager =
      { pkgs, ... }:
      let
        # pkgs.pixi não compila desde que o cargo-setup-hook passou a exportar
        # AWS_LC_SYS_USE_SYSTEM=1; usa o binário estático oficial.
        pixi = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
          pname = "pixi";
          version = "0.83.0";
          src = pkgs.fetchurl {
            url = "https://github.com/prefix-dev/pixi/releases/download/v${finalAttrs.version}/pixi-x86_64-unknown-linux-musl.tar.gz";
            hash = "sha256-Bk83HmkqqjQArFgcidooQ8kUN/IMLZFVOVpdADfzNVE=";
          };
          sourceRoot = ".";
          installPhase = "install -Dm755 pixi $out/bin/pixi";
        });
        orangeIcon = pkgs.fetchurl {
          name = "orange-data-mining.ico";
          url = "https://raw.githubusercontent.com/biolab/orange3/3.40.0/Orange/canvas/icons/orange.ico";
          hash = "sha256-TgRl3Euq5059AkuWXtV1zIZduxURtuTk52JoK01CayI=";
        };
        launcher = pkgs.writeShellScript "orange-data-mining-launcher" ''
          set -eu

          data_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/orange-data-mining"
          mkdir -p "$data_dir"
          install -m 0444 ${./pixi.toml} "$data_dir/pixi.toml"
          install -m 0444 ${./pixi.lock} "$data_dir/pixi.lock"

          cd "$data_dir"
          exec ${pixi}/bin/pixi run --no-config --locked open
        '';

        orange = pkgs.buildFHSEnv {
          name = "orange-data-mining";
          targetPkgs =
            fhsPkgs: with fhsPkgs; [
              pixi
              dbus
              fontconfig
              freetype
              libGL
              libxkbcommon
              wayland
              libx11
              libxcomposite
              libxcursor
              libxdamage
              libxext
              libxfixes
              libxi
              libxinerama
              libxrandr
              libxrender
              libxcb
            ];
          runScript = launcher;
        };

        desktopItem = pkgs.makeDesktopItem {
          name = "orange-data-mining";
          desktopName = "Orange Data Mining";
          genericName = "Data Mining and Visualization";
          comment = "Análise de dados e machine learning por workflows visuais";
          exec = "${orange}/bin/orange-data-mining";
          icon = "${orangeIcon}";
          categories = [
            "Education"
            "Science"
          ];
          terminal = false;
        };
      in
      {
        home.packages = [
          orange
          desktopItem
        ];
      };
  };
}
