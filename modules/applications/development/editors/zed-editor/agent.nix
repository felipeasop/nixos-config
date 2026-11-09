{
  den.aspects.zed-editor = {
    homeManager = { lib, pkgs, ... }: {
      programs.zed-editor = {
        extraPackages = [ pkgs.claude-agent-acp ];

        # "type": "registry" baixa um binário via npx que não roda no NixOS; usa o pacote do nixpkgs.
        userSettings.agent_servers.claude-acp = {
          type = "custom";
          command = lib.getExe pkgs.claude-agent-acp;
          env.ANTHROPIC_API_KEY = "";
        };
      };
    };
  };
}
