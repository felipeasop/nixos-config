# Esqueleto de host reaproveitável: só a infraestrutura mínima que todo
# host vai ter (essential, security, kernel), sem bootloader, sem apps
# desktop, sem secrets — cada host declara essas separadamente porque
# variam por hardware/necessidade (device do grub, se usa sops, etc).
#
# Para criar um novo host:
#   1. copia modules/hosts/template/ pra modules/hosts/<nome>/
#   2. includes = [ standard-host <o que esse host específico precisar> ]
{ den, ... }: {
  den.aspects.standard-host = {
    includes = with den.aspects; [
      essential
      security
      kernel
      kernel-tuning
    ];
  };
}
