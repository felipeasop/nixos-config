# HANDOFF

Last updated: 2026-11-19 UTC

## Estado atual

- Hosts declaram `bootloader`, `kernel`, `browser` e `gpus` (obrigatórios, nos
  `*-schema.nix`). `desktop`: KDE, Niri, Umbriel, `desktop-apps`, CachyOS,
  Zen, AMD. `aspire`: LXQt, Niri, Firefox, Intel.
- `nitro` (i5-13420H + RTX 4050) em `hosts/nitro/_default.nix`, cópia do
  template; o `_` o deixa fora até existir `_hardware.nix`. Intel + NVIDIA
  liga `nvidia-prime` (offload, RTD3); driver para o kernel cachy vem do nyx.
- Caches: nix-community, nyx, umbriel, noctalia; o cache.nixos.org vem do
  módulo do NixOS e o niri.cachix.org está desligado (`pkgs.niri`).
- Base nova: `systemd-oomd` com slices root (pressão e swap) e de usuário,
  poupando o `session.slice`, `fwupd`, sysctl
  `vm.*`, watchdogs, `ntsync`, THP e limites de writeback do CachyOS, BBR
  com fq. No kernel cachy, `scx-loader`
  com `scx_lavd`. NVIDIA com cache de shaders de 8 GiB.
- SSH por opção de host (`features/ssh.nix`): `ssh.hostKey` liga o servidor
  (com fail2ban) e `ssh.deployKey` autoriza deploy como root em todos os
  servidores. Hoje: aspire servidor, desktop cliente. Removidos `polkit.nix` (o NetworkManager já liga o
  polkit), `auto-upgrade.nix` (desligado) e `proton-vpn` (não incluído).
- Stylix: `stylix.nix` só tem o mecanismo; o tema (Everforest dark soft) é
  do `flp`, que o manda ao host pelo `nixos`.
- Estudos: pgAdmin pelo Flatpak (o do nixpkgs segue fora do cache);
  `orange` voltou ao `pkgs.pixi`.
- Deploy do aspire: `nh os switch ~/nixos-config -H aspire --target-host
  root@aspire.local`. Não há gerenciamento de segredos.
- Mudanças pendentes do usuário (fora destes ajustes): `discord.nix`,
  `kde/default.nix`, `audio.nix`.

## Custo de atualização

- `.envrc` usa `nix_direnv_manual_reload`; `nix-direnv-reload` ao mudar o
  lock. Após o `cleanup`, o `flake check --no-build` falha até um dry-run
  baixar o esquema do Stylix.
- chaotic, noctalia e umbriel mantêm o nixpkgs próprio (`flake-duplicates`).

## Decisões adiadas

- Host headless: tirar `graphical` da base; dois usuários com temas
  diferentes conflitariam no tema do sistema.
- Secure Boot (lanzaboote): exige criar e registrar chaves no firmware.

## Próximas ações

1. Separar os commits (caches, revisão de comentários, melhorias) e
   aprovar as mensagens; depois `nh os switch` e conferir notificação do
   Solaar, `scxctl get`, `oomctl`, `sysctl net.ipv4.tcp_congestion_control`, `/dev/ntsync` e
   `/sys/kernel/mm/transparent_hugepage/defrag`.
2. Ativar o nitro: resolver o blocker, gerar `_hardware.nix`, confirmar os
   bus IDs (`lspci -D`) e renomear `_default.nix` para `default.nix`. Para
   o deploy, gerar a chave (`ssh-keygen -t ed25519`), salvá-la em
   `hosts/nitro/deploy.pub` e descomentar `ssh.deployKey`.
3. No aspire, testar as prefs VA-API do Firefox em `intel-graphics.nix`
   (`HARDWARE_VIDEO_DECODING` no `about:support`) e apagar os branches
   `backup/*`.

## Blockers

Nitro: com `enable32Bit` (Steam), o módulo NVIDIA adiciona EGL i686
(`egl-wayland`, `egl-wayland2`, `egl-gbm`, `eglexternalplatform`, mais
moreutils/perl) fora de cache.nixos.org, nix-community e nyx. Opções:
esperar o cache, aceitar compilar, ou tirar só essas EGL 32 bits.

Nenhum segredo foi adicionado aos arquivos rastreados.
