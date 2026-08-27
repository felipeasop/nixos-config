# Config custom, sem logo/imagem (só o ícone Nerd Font da distro),
# emojis nas chaves e clima via wttr.in.
{
  den.aspects.fastfetch = {
    homeManager = _: {
      programs.fastfetch = {
        enable = true;
        # O Home Manager recebe um attrset Nix; manter a fonte em JSON
        # também permite validar e testar o visual direto com fastfetch.
        settings = builtins.fromJSON (builtins.readFile ./config.json);
      };
    };
  };
}
