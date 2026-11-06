{
  den.aspects.zed-editor = {
    homeManager =
      {
        config,
        lib,
        pkgs,
        osConfig ? null,
        ...
      }:
      let
        flake = ''(builtins.getFlake "${config.home.homeDirectory}/nixos-config")'';
        host = "${flake}.nixosConfigurations.${osConfig.networking.hostName}";
        nixfmt-strict = pkgs.writeShellScriptBin "nixfmt" ''
          exec ${lib.getExe pkgs.nixfmt} --strict "$@"
        '';
      in
      {
        home.packages = [ nixfmt-strict ];

        stylix.targets.zed.fonts.enable = false;

        programs.zed-editor = {
          enable = true;

          extensions = [
            "nix"
            "toml"
          ];

          extraPackages = with pkgs; [
            nil
            nixd
            nixfmt-strict
            claude-agent-acp
          ];

          userSettings = {
            node = {
              path = lib.getExe pkgs.nodejs;
              npm_path = lib.getExe' pkgs.nodejs "npm";
            };

            # "type": "registry" baixa um binário via npx que não roda no NixOS; usa o pacote do nixpkgs.
            agent_servers.claude-acp = {
              type = "custom";
              command = lib.getExe pkgs.claude-agent-acp;
              env.ANTHROPIC_API_KEY = "";
            };

            buffer_font_family = "JetBrainsMono Nerd Font";
            ui_font_family = "JetBrainsMono Nerd Font";
            buffer_font_size = 14;
            ui_font_size = 14;

            languages.Nix = {
              semantic_tokens = "combined";
              format_on_save = "on";
              formatter.external = {
                command = "nixfmt";
                arguments = [ "-" ];
              };
            };

            lsp = {
              nil.settings.nix.flake.autoArchive = true;
              nixd.settings = {
                nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
                options = lib.optionalAttrs (osConfig != null) {
                  nixos.expr = "${host}.options";
                  home-manager.expr = "${host}.options.home-manager.users.type.getSubOptions [ ]";
                };
              };
            };
          };
        };
      };
  };
}
