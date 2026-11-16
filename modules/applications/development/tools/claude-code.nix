{
  den.aspects.claude-code = {
    homeManager = { config, ... }: {
      programs.claude-code = {
        enable = true;
        configDir = "${config.xdg.configHome}/claude";
        mutableSettings = true;
        settings = {
          attribution = {
            commit = "";
            pr = "";
          };
          permissions = {
            allow = [
              "Bash(nix eval *)"
              "Bash(nix flake check --no-build *)"
              "Bash(nix flake show *)"
              "Bash(nix flake metadata *)"
              "Bash(nix build --dry-run *)"
              "Bash(nix path-info *)"
              "Bash(nix derivation show *)"
              "Bash(nix why-depends *)"
              "Bash(nix log *)"
              "Bash(nix search *)"
              "Bash(nix-instantiate --eval *)"
              "Bash(nix-store --query *)"
              "Bash(nix-diff *)"
              "Bash(nix fmt *)"
              "Bash(nix run nixpkgs#*)"
              "Bash(nix shell nixpkgs#*)"
              "Bash(nix run .#*)"
              "Bash(jq *)"
              "Bash(systemctl status *)"
              "Bash(journalctl *)"
              "Bash(lspci *)"
            ];
            ask = [
              "Bash(sudo *)"
              "Bash(nix flake update *)"
              "Bash(nixos-rebuild *)"
              "Bash(nixos-generate-config *)"
              "Bash(nh os *)"
              "Bash(nh home *)"
              "Bash(home-manager *)"
              "Bash(nix-collect-garbage *)"
              "Bash(nix store gc *)"
              "Bash(nix store delete *)"
              "Bash(nix-store --gc *)"
              "Bash(nix-store --delete *)"
              "Bash(nix run github:*)"
              "Bash(nix run gitlab:*)"
              "Bash(nix run git+*)"
              "Bash(nix run http*)"
              "Bash(nix shell github:*)"
              "Bash(nix shell gitlab:*)"
              "Bash(nix shell git+*)"
              "Bash(nix shell http*)"
              "Bash(nix-shell *)"
              "Bash(npx *)"
              "Bash(uvx *)"
              "Bash(pipx *)"
              "Bash(go install *)"
              "Bash(curl *)"
              "Bash(wget *)"
              "Bash(xh *)"
            ];
            deny = [
              "Edit(~/nixos-config/flake.nix)"
              "Edit(~/nixos-config/flake.lock)"
              "Edit(~/nixos-config/**/_hardware.nix)"
              "Edit(//etc/**)"
              "Edit(//nix/**)"
              "Edit(~/.config/claude/settings.json)"
              "Bash(nix-env *)"
              "Bash(nix profile *)"
              "Bash(nix-channel *)"
              "Bash(nix registry add *)"
              "Bash(nix registry pin *)"
              "Bash(nix registry remove *)"
              "Bash(nix upgrade-nix *)"
              "Bash(systemctl enable *)"
              "Bash(systemctl disable *)"
              "Bash(systemctl mask *)"
              "Bash(systemctl edit *)"
              "Bash(systemctl --user enable *)"
              "Bash(systemctl --user disable *)"
              "Bash(systemctl --user mask *)"
              "Bash(systemctl --user edit *)"
              "Bash(flatpak install *)"
              "Bash(flatpak uninstall *)"
              "Bash(pip install *)"
              "Bash(* install -g *)"
              "Bash(* install --global *)"
              "Bash(* i -g *)"
              "Bash(* add -g *)"
              "Bash(* add --global *)"
              "Bash(* global add *)"
              "Bash(cargo install *)"
            ];
          };
        };
      };
    };
  };
}
