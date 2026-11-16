{ den, lib, ... }:
let
  browsers = {
    zen-browser = {
      desktopId = "zen-beta.desktop";
      privateFlag = "--private-window";
    };
    firefox = {
      desktopId = "firefox.desktop";
      privateFlag = "--private-window";
    };
  };
in
{
  den = {
    schema.host.options.browser = lib.mkOption {
      type = lib.types.enum (lib.attrNames browsers);
      description = "Navegador principal: instalado e padrão para links e atalhos.";
    };

    aspects.default-browser = { host, ... }: {
      provides.to-users = {
        includes = [ den.aspects.${host.browser} ];

        homeManager =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          let
            browser = browsers.${host.browser};
            exe = lib.getExe config.programs.${host.browser}.finalPackage;
            # Mesmo --name do .desktop, para a barra de tarefas associar a janela ao ícone.
            launch = "${exe} --name ${lib.removeSuffix ".desktop" browser.desktopId}";
          in
          {
            xdg.mimeApps = {
              enable = true;
              defaultApplications = lib.genAttrs [
                "text/html"
                "application/xhtml+xml"
                "x-scheme-handler/http"
                "x-scheme-handler/https"
              ] (_: browser.desktopId);
            };

            home.packages = [
              (pkgs.writeShellScriptBin "default-browser" ''
                if [ "''${1-}" = --private ]; then
                  exec ${launch} ${browser.privateFlag}
                fi
                exec ${launch}
              '')
            ];
          };
      };
    };
  };
}
