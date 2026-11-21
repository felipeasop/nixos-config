{ inputs, ... }: {
  flake-file.inputs = {
    nixcord = {
      url = "github:4evy/nixcord";
      # Os demais só servem ao CI, devShells e packages do nixcord, que esta config não usa.
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-ci.follows = "nixpkgs";
        nixpkgs-packages.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
  };

  den.aspects.discord = {
    homeManager = { ... }: {
      imports = [ inputs.nixcord.homeModules.nixcord ];

      stylix.targets.nixcord.enable = true;

      programs.nixcord = {
        enable = true;

        discord = {
          equicord.enable = true;
          krisp.enable = true;

          settings = {
            enableHardwareAcceleration = false;
            openasar = {
              setup = true;
              # "perf" só soma flags de GPU (inúteis sem aceleração) e força a dGPU no laptop.
              cmdPreset = "battery";
              noTrack = true;
              noTyping = false;
              themeSync = true;
              quickstart = false;
              multiInstance = false;
            };
          };
        };

        config = {
          autoUpdate = true;
          autoUpdateNotification = true;

          plugins = {
            # Correções de conteúdo e navegação
            fixYoutubeEmbeds.enable = true;
            fixSpotifyEmbeds.enable = true;
            validReply.enable = true;
            validUser.enable = true;
            fullSearchContext.enable = true;
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
            pictureInPicture.enable = true;
            replyTimestamp.enable = true;
            viewIcons.enable = true;
            voiceMessages.enable = true;

            # QOL
            clearUrls.enable = true;
            crashHandler.enable = true;
            noOnboardingDelay.enable = true;
            noTrack.enable = true;
            noTypingAnimation.enable = true;
            youtubeAdblock.enable = true;
            musicControls.enable = true;
          };
        };
      };
    };
  };
}
