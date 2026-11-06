{
  den.aspects.cli = {
    homeManager = { pkgs, ... }: {
      programs = {
        bat.enable = true;
        btop.enable = true;
        fzf.enable = true;
      };

      home.packages = with pkgs; [
        # básicos
        micro
        tree
        ripgrep # grep
        fd # find
        eza # ls

        # monitoramento
        htop

        # rede
        curl
        wget
        dnsutils

        # arquivos compactados
        unzip
        zip

        # dados
        jq
        yq-go

        # utilidades
        killall
        file
        which

        fastfetch
      ];
    };
  };
}
