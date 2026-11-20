# Config custom: logo NixOS em ASCII e ícones Nerd Font nas chaves.
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
