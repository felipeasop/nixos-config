{ inputs, ... }: {
  flake-file.inputs = {
    go-live-bypass = {
      url = "github:bezumiya/GoLiveBypass";
      flake = false;
    };

    nixcord = {
      url = "github:4evy/nixcord";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-nixcord.follows = "nixpkgs";
      };
    };
  };

  den.aspects.discord = {
    homeManager =
      { pkgs, ... }:
      let
        goLiveBypassPlugin = pkgs.runCommand "vencord-plugin-go-live-bypass" { } ''
          mkdir -p "$out"
          cp -r ${inputs.go-live-bypass}/goLiveBypass/. "$out/"
        '';
      in
      {
        imports = [ inputs.nixcord.homeModules.nixcord ];

        programs.nixcord = {
          enable = true;

          # O cliente oficial permanece desabilitado; o Vesktop é o único cliente.
          discord.enable = false;

          vesktop = {
            enable = true;
            useSystemVencord = true;

            # Configurações do cliente, gravadas em
            # ~/.config/vesktop/settings.json pelo próprio Nixcord.
            settings = {
              discordBranch = "stable";
              tray = true;
              minimizeToTray = true;
              clickTrayToShowHide = true;
              hardwareAcceleration = true;
              disableMinSize = true;
              customTitleBar = false;
              arRPC = true;
              spellCheckLanguages = [
                "pt-BR"
                "en-US"
              ];

              # O Vesktop usa PipeWire/venmic no Linux. A seleção granular
              # permite escolher fontes por aplicação sem expor dispositivos
              # de entrada como microfones no seletor de áudio da transmissão.
              audio = {
                granularSelect = true;
                ignoreDevices = true;
                ignoreInputMedia = true;
                onlySpeakers = true;
                onlyDefaultSpeakers = true;
              };
            };
          };

          # Plugin externo, compilado junto do Vencord gerenciado pelo Nix.
          userPlugins.GoLiveBypass = goLiveBypassPlugin;

          extraConfig.plugins.GoLiveBypass = {
            enable = true;
            excludedCountries = "BR";
            proxy = "";
            sessionRouting = "gateway";
            streamRegion = "";
            voiceRegion = "";
          };

          config.plugins = {
            # Transmissão no cliente Chromium/Vesktop.
            webScreenShare = {
              enable = true;
              resolution = "1080";
              frameRate = "60";
              contentHint = "motion";
              systemAudio = false;
            };

            webScreenShareFixes.enable = true;
            biggerStreamPreview.enable = true;
            streamerModeOnStream.enable = true;

            # Recursos de desktop ausentes ou incompletos no cliente web.
            webContextMenus.enable = true;
            webKeybinds.enable = true;
            pictureInPicture.enable = true;
            voiceMessages.enable = true;

            # Correções de conteúdo e navegação.
            fixYoutubeEmbeds.enable = true;
            fixSpotifyEmbeds.enable = true;
            validReply.enable = true;
            validUser.enable = true;
            fullSearchContext.enable = true;
            fullUserInChatbox.enable = true;
            messageLinkEmbeds.enable = true;
            unsuppressEmbeds.enable = true;
            unindent.enable = true;

            # Melhorias previsíveis de interface e mídia.
            betterGifAltText.enable = true;
            betterSettings.enable = true;
            betterSessions.enable = true;
            copyFileContents.enable = true;
            imageZoom.enable = true;
            keepCurrentChannel.enable = true;
            replyTimestamp.enable = true;
            viewIcons.enable = true;

            # Estabilidade, desempenho e privacidade.
            clearUrls.enable = true;
            crashHandler.enable = true;
            noOnboardingDelay.enable = true;
            noTrack.enable = true;
            noTypingAnimation.enable = true;
            youtubeAdblock.enable = true;

            # Integração explicitamente útil para quem usa Spotify.
            spotifyControls.enable = true;
          };
        };
      };
  };
}
