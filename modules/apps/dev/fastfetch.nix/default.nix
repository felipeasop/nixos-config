# Config custom, sem logo/imagem (só o ícone Nerd Font da distro),
# emojis nas chaves e clima via wttr.in.
{ inputs, ... }: {
  den.aspects.fastfetch = {
    homeManager = _: {
      programs.fastfetch = {
        enable = true;
        # fromJSON não lê comentários, então a fonte legível fica em
        # config.jsonc (documentação) e a versão limpa em config.json
        # é a que realmente é lida aqui.
        settings = builtins.fromJSON (
          builtins.readFile "${inputs.self}/modules/apps/dev/fastfetch.nix/config.json"
        );
      };
    };
  };
}
