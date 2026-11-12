{
  den.aspects.cli = {
    homeManager = { pkgs, ... }: {
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
        fzf.enable = true;
        jq.enable = true;
        micro.enable = true;
        ripgrep.enable = true;
        tealdeer.enable = true;
        zoxide = {
          enable = true;
          options = [ "--cmd cd" ];
        };
      };

      home.packages = with pkgs; [
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
}
