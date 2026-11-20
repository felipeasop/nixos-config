# TRIM semanal para SSDs (SATA ou NVMe) manterem a performance de escrita.
# Em HDD é inofensivo: o serviço pula dispositivos sem suporte a discard.
{
  den.aspects.essential = {
    nixos = {
      services.fstrim.enable = true;
    };
  };
}
