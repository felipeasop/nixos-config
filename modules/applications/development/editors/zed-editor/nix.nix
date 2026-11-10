let
  flake = home: ''(builtins.getFlake "${home}/nixos-config")'';
in
{
  den.aspects.zed-editor = {
    homeManager = { config, pkgs, ... }: {
      home.packages = [ pkgs.nixfmt ];

      programs.zed-editor = {
        extensions = [ "nix" ];

        extraPackages = with pkgs; [
          nil
          nixd
          nixfmt
        ];

        userSettings = {
          languages.Nix = {
            semantic_tokens = "combined";
            format_on_save = "on";
            formatter.external = {
              command = "nixfmt";
              arguments = [ "-" ];
            };
          };

          lsp = {
            nil.settings.nix.flake.autoArchive = false;
            nixd.settings.nixpkgs.expr = "import ${flake config.home.homeDirectory}.inputs.nixpkgs { }";
          };
        };
      };
    };

    # Só dispara com host: num home standalone não há opções de NixOS para o nixd.
    includes = [
      ({ host, ... }: {
        homeManager = { config, ... }: {
          programs.zed-editor.userSettings.lsp.nixd.settings.options =
            let
              system = "${flake config.home.homeDirectory}.nixosConfigurations.${host.hostName}";
            in
            {
              nixos.expr = "${system}.options";
              home-manager.expr = "${system}.options.home-manager.users.type.getSubOptions [ ]";
            };
        };
      })
    ];
  };
}
