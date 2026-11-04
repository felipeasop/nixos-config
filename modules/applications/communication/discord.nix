{ inputs, ... }: {
  flake-file.inputs = {
    nixcord = {
      url = "github:4evy/nixcord";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-nixcord.follows = "nixpkgs";
      };
    };
  };

  den.aspects.discord = {
    homeManager = { ... }: {
      imports = [ inputs.nixcord.homeModules.nixcord ];

      programs.nixcord = {
        enable = true;

        # O cliente oficial permanece desabilitado; o Vesktop é o único cliente.
        discord.enable = false;

        vesktop = {
          enable = true;
          useSystemVencord = true;
          settings = {
            discordBranch = "stable";
            tray = true;
            minimizeToTray = true;
            clickTrayToShowHide = true;
            hardwareAcceleration = false;
            disableMinSize = true;
            customTitleBar = false;
            arRPC = true;
            spellCheckLanguages = [
              "pt-BR"
              "en-US"
            ];

            audio = {
              granularSelect = true;
              ignoreDevices = true;
              ignoreInputMedia = true;
              onlySpeakers = true;
              onlyDefaultSpeakers = true;
            };
          };
        };

        config.plugins = {
          # Recursos de desktop ausentes ou incompletos no cliente web
          webContextMenus.enable = true;
          webKeybinds.enable = true;
          pictureInPicture.enable = true;
          voiceMessages.enable = true;

          # Correções de conteúdo e navegação
          fixYoutubeEmbeds.enable = true;
          fixSpotifyEmbeds.enable = true;
          validReply.enable = true;
          validUser.enable = true;
          fullSearchContext.enable = true;
          fullUserInChatbox.enable = true;
          messageLinkEmbeds.enable = true;
          unsuppressEmbeds.enable = true;
          unindent.enable = true;

          # Interface e mídia
          betterGifAltText.enable = true;
          betterSettings.enable = true;
          betterSessions.enable = true;
          copyFileContents.enable = true;
          imageZoom.enable = true;
          keepCurrentChannel.enable = true;
          replyTimestamp.enable = true;
          viewIcons.enable = true;

          # QOL
          clearUrls.enable = true;
          crashHandler.enable = true;
          noOnboardingDelay.enable = true;
          noTrack.enable = true;
          noTypingAnimation.enable = true;
          youtubeAdblock.enable = true;
          spotifyControls.enable = true;
        };
      };
    };
  };
}
