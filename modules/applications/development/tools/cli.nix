{
  den.aspects.cli = {
    homeManager = { pkgs, ... }: {
      programs = {
        bat.enable = true;
        btop.enable = true;
        eza.enable = true;
        fastfetch.enable = true;
        fd.enable = true;
        fzf.enable = true;
        htop.enable = true;
        jq.enable = true;
        micro.enable = true;
        ripgrep.enable = true;
      };

      home.packages = with pkgs; [
        # básicos
        tree

        # rede
        curl
        wget
        dnsutils

        # arquivos compactados
        unzip
        zip

        # dados
        yq-go

        # utilidades
        killall
        file
        which
      ];
    };
  };
}
