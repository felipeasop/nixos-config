# HANDOFF

Last updated: 2026-11-21 UTC

## Estado atual

- Hosts declaram `bootloader`, `kernel`, `browser` e `gpus` (obrigatórios, nos
  `*-schema.nix`). `desktop`: KDE, Niri, Umbriel, `desktop-apps`, CachyOS,
  Zen, AMD. `aspire` (i3, 4 GiB DDR3): LXQt, Niri, Firefox, Intel.
- `nitro` (i5-13420H + RTX 4050) em `hosts/nitro/_default.nix`, cópia do
  template; o `_` o deixa fora até existir `_hardware.nix`.
- Caches: nix-community, nyx, umbriel, noctalia; o cache.nixos.org vem do
  módulo do NixOS e o niri.cachix.org está desligado (`pkgs.niri`).
- SSH por opção de host (`features/ssh.nix`): aspire servidor, desktop
  cliente. Deploy do aspire: `nh os switch ~/nixos-config -H aspire
  --target-host root@aspire.local`. Não há gerenciamento de segredos.
- Stylix: `stylix.nix` só tem o mecanismo; o tema (Everforest dark soft) é
  do `flp`, que o manda ao host pelo `nixos`.
- Enxugamento do closure: Prism só com JDK 21 e 25; Orca e speech-dispatcher
  desligados; LibreOffice trocado pelo OnlyOffice (homeManager, fontes do
  Stylix e Liberation no FHS). Papéis de parede do Plasma ficam.
- `features/printing.nix` (CUPS, ipp-usb, drivers comentados) existe, mas
  nenhum host o inclui; o aspire ainda liga a impressão pelo `lxqt`.
- Estudos (orange, pgadmin) ficam no `desktop-apps`, fora do aspire.
- Checks e dry-runs só quando o usuário pedir (AGENTS.md).
- Pendente do usuário, sem commit: `fastfetch/config.json` (cores da logo).

## Custo de atualização

- `.envrc` usa `nix_direnv_manual_reload`; `nix-direnv-reload` ao mudar o
  lock. Após o `cleanup`, o `flake check --no-build` falha até um dry-run
  baixar o esquema do Stylix.
- chaotic, noctalia e umbriel mantêm o nixpkgs próprio (`flake-duplicates`).

## Decisões adiadas

- Host headless: tirar `graphical` da base; dois usuários com temas
  diferentes conflitariam no tema do sistema.
- Secure Boot (lanzaboote): exige criar e registrar chaves no firmware.
- Aspecto `study` separado do `desktop-apps` para o aspire (Orange,
  Postgres nativo, `pgcli` no lugar do pgAdmin).

## Próximas ações

1. `nh os switch` no desktop com o lock novo e as mudanças de closure.
2. Mover a impressão do `lxqt` para o aspecto `printing` nos hosts.
3. Ativar o nitro: gerar `_hardware.nix`, confirmar bus IDs (`lspci -D`),
   renomear `_default.nix` e gerar a chave de deploy.

## Blockers

Nitro: com `enable32Bit` (Steam), o módulo NVIDIA adiciona EGL i686 fora
dos caches. Opções: esperar o cache, aceitar compilar, ou tirar só essas
EGL 32 bits.

Nenhum segredo foi adicionado aos arquivos rastreados.
