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

        # git/jujutsu: também habilitados com identidade em
        # apps/dev/git/git.nix e git/jujutsu.nix (programs.*.enable).
        # Mantidos aqui pra estarem disponíveis mesmo se o aspect
        # git/jujutsu daquele arquivo for removido de algum host/user.
        jujutsu
        git

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
