{
  den.aspects.essential = {
    # Desabilitado: tentar usar o pacote certo do nixpkgs ou buildFHSEnv antes disso
    # Ativar por host com lib.mkForce true
    nixos.programs.nix-ld.enable = false;
  };
}
