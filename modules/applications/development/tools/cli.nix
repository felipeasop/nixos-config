{
  den.aspects.cli = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        # básicos
        micro
        tree
        ripgrep # grep
        fd # find
        fzf
        bat # cat
        eza # ls

        # monitoramento
        htop
        btop

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

        # fastfetch
        fastfetch
      ];
    };
  };
}
