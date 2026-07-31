{ inputs, ... }:
{
  den.aspects.git.provides.to-hosts.nixos =
    { config, ... }:
    {
      sops.secrets.github_token = {
        sopsFile = "${inputs.self}/secrets/secrets.yaml";
        key = "github/token";
        mode = "0400";
        owner = "root";
      };

      sops.templates."nix-github-token.conf" = {
        content = "access-tokens = github.com=${config.sops.placeholder.github_token}";
        mode = "0400";
        owner = "root";
      };

      nix.extraOptions = ''
        !include ${config.sops.templates."nix-github-token.conf".path}
      '';
    };
}
