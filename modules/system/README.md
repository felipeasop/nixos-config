# system

Base do sistema: Nix, boot, kernel.

- **bootloader/** — GRUB, systemd-boot.
- **kernel/** — Cachy ou latest (escolher um).
- **essential/** — rede, áudio, fontes, locale, SSH, zram, configs do Nix.
- **den.nix** — framework de aspects/hosts.
- **schema/** — schemas obrigatórios.
