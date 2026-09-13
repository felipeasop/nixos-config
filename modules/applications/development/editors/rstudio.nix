{
  den.aspects.rstudio = {
    homeManager =
      { pkgs, ... }:
      let
        version = "2026.04.0+526";
        archiveVersion = builtins.replaceStrings [ "+" ] [ "-" ] version;
        description = "Integrated development environment for R";

        rstudio-unwrapped = pkgs.stdenvNoCC.mkDerivation {
          pname = "rstudio-bin-unwrapped";
          inherit version;

          src = pkgs.fetchurl {
            url = "https://download1.rstudio.org/electron/jammy/amd64/rstudio-${archiveVersion}-amd64-debian.tar.gz";
            hash = "sha256-0vaJLM5LS4lLfPx4R+Dh7Pwx2ZRqx6WSXDWE9JzP1Xs=";
          };

          installPhase = ''
            runHook preInstall

            mkdir -p "$out/lib/rstudio" "$out/bin"
            cp -r . "$out/lib/rstudio"
            ln -s ../lib/rstudio/rstudio "$out/bin/rstudio"

            runHook postInstall
          '';

          dontStrip = true;

          meta = {
            inherit description;
            homepage = "https://posit.co/products/open-source/rstudio/";
            license = pkgs.lib.licenses.agpl3Only;
            mainProgram = "rstudio";
            platforms = [ "x86_64-linux" ];
            sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
          };
        };

        desktopItem = pkgs.makeDesktopItem {
          name = "rstudio";
          desktopName = "RStudio";
          comment = description;
          exec = "rstudio %F";
          icon = "${rstudio-unwrapped}/lib/rstudio/resources/app/rstudio.png";
          categories = [ "Development" ];
          mimeTypes = [ "text/x-r-source" ];
        };

        rstudio = pkgs.buildFHSEnv {
          name = "rstudio";
          runScript = pkgs.writeShellScript "rstudio-launch" ''
            export RSTUDIO_WHICH_R=${pkgs.R}/bin/R
            exec ${rstudio-unwrapped}/bin/rstudio "$@"
          '';

          targetPkgs =
            p: with p; [
              rstudio-unwrapped
              R
              alsa-lib
              at-spi2-atk
              cairo
              cups
              dbus
              expat
              gdk-pixbuf
              glib
              gtk3
              libdrm
              libgbm
              libGL
              libnotify
              libpulseaudio
              libsecret
              libx11
              libxcb
              libxcomposite
              libxdamage
              libxext
              libxfixes
              libxkbcommon
              libxrandr
              libxshmfence
              nspr
              nss
              pango
              pipewire
              speechd-minimal
              systemd
              vulkan-loader
            ];

          extraInstallCommands = ''
            mkdir -p "$out/share"
            ln -s ${desktopItem}/share/applications "$out/share/applications"
          '';

          inherit (rstudio-unwrapped) meta;
        };
      in
      {
        home.packages = [ rstudio ];
      };
  };
}
