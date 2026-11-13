{
  den.aspects.obsidian = {
    homeManager = {
      programs.obsidian = {
        enable = true;
        vaults."Documentos/Obsidian Vault" = { };
      };

      stylix.targets.obsidian = {
        enable = true;
        vaultNames = [ "Documentos/Obsidian Vault" ];
      };
    };
  };
}
