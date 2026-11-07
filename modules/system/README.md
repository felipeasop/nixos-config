# system

Base do sistema: Nix, boot, kernel.

- **bootloader/** — GRUB, systemd-boot.
- **kernel/** — Cachy ou latest (escolher um) e ajustes de sysctl.
- **essential/** — rede, locale, SSH, zram, journald, fstrim e configs do Nix;
  vale para qualquer máquina, inclusive sem tela.
- **flatpak/** — Flatpak declarativo.

Áudio fica em `modules/features/`; X11 e o tema (Stylix) chegam pelo aspect
`graphical`, em `modules/desktop/session/` e `modules/desktop/theme/`.
