# TRIM automático semanal — necessário pra SSDs (SATA ou NVMe) manterem
# performance de escrita ao longo do tempo. Se o host for só HDD, isso
# não faz mal nenhum (o comando simplesmente não encontra blocos TRIM-áveis).
{
  den.aspects.essential = {
    nixos = {
      services.fstrim.enable = true;
    };
  };
}
