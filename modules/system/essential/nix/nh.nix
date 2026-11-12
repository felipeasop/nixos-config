let
  # Mesma política na limpeza semanal e no comando detox.
  cleanArgs = "--keep-since 7d --keep 3 --keep-one";
in
{
  den.aspects.essential = {
    nixos = { config, pkgs, ... }: {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = cleanArgs;
          dates = "weekly";
        };
      };

      environment.systemPackages = [
        pkgs.nix-output-monitor

        # Limpeza sob demanda: gerações e lixo do Nix pela política acima,
        # deduplicação do store e runtimes Flatpak sem uso.
        (pkgs.writeShellApplication {
          name = "detox";
          runtimeInputs = [ config.programs.nh.package ];
          text = ''
            nh clean all ${cleanArgs} --optimise
            if command -v flatpak >/dev/null; then
              flatpak uninstall --unused --noninteractive
            fi
          '';
        })
      ];
    };

    homeManager = { config, ... }: {
      home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/nixos-config";
    };
  };
}
