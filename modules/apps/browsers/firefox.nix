# modules/apps/browsers/firefox.nix
{
  den.aspects.firefox = {
    homeManager = {
      programs.firefox = {
        enable = true;

        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableFeedbackCommands = true;
          DontCheckDefaultBrowser = true;
          OfferToSaveLogins = true;

          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
        };

        profiles.default = {
          settings = {
            # Restaurar abas/janelas da sessão anterior ao abrir
            "browser.startup.page" = 3;

            # Avisa sites sobre prefers-color-scheme: dark. A UI do
            # próprio Firefox segue o portal xdg (ver modules/desktop/wm/xdg.nix,
            # backend gtk fixado no Settings), não precisa forçar tema aqui.
            "ui.systemUsesDarkTheme" = 1;

            # Privacidade
            "privacy.donottrackheader.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "privacy.fingerprintingProtection" = true;
            "privacy.resistFingerprinting" = false; # true quebra bastante site; ligue manualmente se topar o trade-off
            "network.cookie.cookieBehavior" = 1; # bloqueia cookies de terceiros
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
