{
  den.aspects.zed-editor = {
    homeManager = { lib, pkgs, ... }: {
      programs.zed-editor = {
        enable = true;

        extensions = [
          "everforest-theme"
          "nix"
          "toml"
        ];

        extraPackages = with pkgs; [
          nil
          nixd
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
        };
      };
    };
  };
}
