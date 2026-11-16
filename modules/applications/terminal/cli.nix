{
  den.aspects.cli = {
    homeManager = { pkgs, ... }: {
      stylix.targets = {
        bat.enable = true;
        btop.enable = true;
        fzf.enable = true;
        micro.enable = true;
      };

      programs = {
        bat.enable = true;
        btop.enable = true;
        delta = {
          enable = true;
          enableGitIntegration = true;
          enableJujutsuIntegration = true;
        };
        eza = {
          enable = true;
          # Os aliases com eza ficam em fish/aliases.nix.
          enableFishIntegration = false;
        };
        fd.enable = true;
        fzf = {
          enable = true;
          # Os atalhos (Ctrl+R etc.) vêm do plugin fzf-fish.
          enableFishIntegration = false;
        };
        jq.enable = true;
        micro.enable = true;
        ripgrep.enable = true;
        tealdeer.enable = true;
        zoxide = {
          enable = true;
          options = [ "--cmd cd" ];
        };
      };

      home = {
        sessionVariables = {
          MANROFFOPT = "-c";
          MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        };

        packages = with pkgs; [
          yq-go

          # Substitutos modernos: du, df, ps, sed, dig, curl, ping, jq e zip/unzip.
          dust
          duf
          procs
          sd
          doggo
          xh
          gping
          jaq
          ouch
        ];
      };
    };
  };
}
