{
  den.aspects.firefox = {
    homeManager = {
      stylix.targets.firefox = {
        enable = true;
        profileNames = [ "default" ];
      };

      programs.firefox = {
        enable = true;

        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableFeedbackCommands = true;
          DontCheckDefaultBrowser = true;
          OfferToSaveLogins = true;

          ExtensionSettings."uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };

          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
        };

        profiles.default = {
          settings = {
            "browser.startup.page" = 3;

            "privacy.donottrackheader.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "privacy.fingerprintingProtection" = true;
            "privacy.resistFingerprinting" = false;
            "network.cookie.cookieBehavior" = 1;
            "browser.contentblocking.category" = "strict";
            "dom.security.https_only_mode" = true;
            "beacon.enabled" = false;
            "browser.send_pings" = false;
          };
        };
      };
    };
  };
}
