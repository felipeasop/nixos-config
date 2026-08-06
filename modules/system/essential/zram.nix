# Swap comprimido na RAM. Mais rápido que swap em disco e reduz a
# pressão de I/O; a partição de swap em disco (sda2) continua existindo
# como fallback caso o zram sature.
{
  den.aspects.essential = {
    nixos = {
      zramSwap = {
        enable = true;
        memoryPercent = 50;
        priority = 100;
        algorithm = "zstd";
      };
    };
  };
}
