# modules/apps/browsers/zen-browser.nix
{ inputs, ... }:
{
  flake-file.inputs.zen-browser = {
    url = "github:0xc000022070/zen-browser-flake";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      home-manager.follows = "home-manager";
    };
  };

  den.aspects.zen-browser = {
    homeManager = {
      imports = [ inputs.zen-browser.homeModules.beta ];

      programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;

        policies = {
          DisableAppUpdate = true; # Nix já gerencia updates
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
          # Betterfox preset: prefs de privacidade, telemetria e
          # performance (yokoffing/Betterfox zen/user.js) que o Zen não
          # aplica por padrão. Cada pref usa mkDefault, então qualquer
          # entrada em `settings` abaixo tem prioridade e sobrescreve.
          # Desativar o preset reverte as prefs que ele aplicou.
          presets.betterfox.enable = true;

          settings = {
            "zen.view.compact.enable-at-startup" = true;
            "zen.workspaces.continue-where-left-off" = true;

            # Restaurar abas/janelas da sessão anterior. Sem mkDefault de
            # propósito: o preset betterfox desativa isso por padrão
            # (privacidade), então aqui precisa ter prioridade sobre o preset.
            "browser.startup.page" = 3;
          };

          # Search: Startpage não é engine nativa, é fornecida pela extensão,
          # o `default` é só o fallback nativo, depois que a extensão instalar,
          # defina Startpage como padrão manualmente em about:preferences#search.
          search = {
            force = true;
            default = "ddg";
            engines = {
              google.metaData.alias = "@g";
              ddg.metaData.alias = "@ddg";
            };
          };

          # Só "Faculdade" tem container; o resto usa o contexto padrão.
          containersForce = true;
          containers.Faculdade = {
            color = "orange";
            icon = "briefcase";
          };

          spacesForce = true;
          spaces = {
            "Lazer" = {
              id = "740c3c0d-08f4-4c31-b64c-16bf57f75fe7";
              position = 1000;
              icon = "🦣";
            };

            "Tux" = {
              id = "465c6cc6-5087-4816-9005-70eacb3f45c1";
              position = 2000;
              icon = "🐧";
            };

            "Projetos" = {
              id = "f347ce01-3e2d-45d7-b13d-dd9544964b60";
              position = 3000;
              icon = "🫡";
            };

            "Faculdade" = {
              id = "7c9ee082-757b-425f-9c7b-7d029686cee4";
              position = 4000;
              icon = "🥵";
              container = 1;
            };
          };

          # Sem pins ou bookmarks declarados
        };
      };
    };
  };
}
