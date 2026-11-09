# Swap comprimido na RAM. Mais rápido que swap em disco e reduz a
# pressão de I/O; o swap em disco do host, se houver, fica como fallback
# pela prioridade menor caso o zram sature.
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
