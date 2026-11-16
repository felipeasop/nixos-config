# HANDOFF

Last updated: 2026-11-16 UTC

## Estado atual

- Hosts declaram `bootloader`, `kernel`, `browser` e `gpus` (obrigatórios, nos
  `*-schema.nix`). `desktop`: KDE, Niri, Umbriel, `desktop-apps`, CachyOS,
  Zen, AMD. `aspire`: LXQt, Niri, Firefox, Intel.
- `nitro` (i5-13420H + RTX 4050) em `hosts/nitro/_default.nix`, cópia do
  template; o `_` o deixa fora até existir `_hardware.nix`. Intel + NVIDIA
  liga `nvidia-prime` (offload, RTD3); CUDA só pelo driver;
  `nvidia-settings` desligado (fora do cache).
- `default-browser [--private]` usa o navegador do host; `mimeapps.list`
  pelo HM; atalhos iguais em niri, KDE e LXQt.
- `modules/defaults.nix`: `den.default` (define-user, essential, git,
  xdg-base-dirs); o host inclui `hostname`, `graphical`, `default-browser`,
  `bootloader`, `kernel`, `gpu`, `user-aspects` e o resto da base; o usuário
  de host inclui `host-aspects`. `provides.*` só onde é necessário (ver
  `AGENTS.md`).
- Stylix: `stylix.nix` só tem o mecanismo; o tema (Everforest dark soft) é
  do `flp`, que o manda ao host pelo `nixos`.
- XDG: `use-xdg-base-directories`; bash pelo HM; Claude Code em
  `~/.config/claude`; sem o agente do Zed.
- uBlock Origin por política no Zen e no Firefox. Abas antigas do backup do
  Zen juntadas; original em
  `~/.config/zen/default/zen-sessions.jsonlz4.antes-abas-antigas`.
- Umbriel: `compositors/umbriel/` espelha o niri seção a seção (diferenças
  e extras em comentários). `desktop` inclui o `umbriel-stack` ao lado do
  `niri-stack`; o pacote vem do umbriel.cachix (sem compilação local).
- fish enxuto: plugins do `pkgs.fishPlugins`, atalhos do fzf pelo
  `fzf-fish`, só `history` e `backup` como funções (Alt+S e Alt+. no lugar
  de `!!` e `!$`).
- Estudos: pgAdmin pelo Flatpak (o do nixpkgs falha no Hydra desde
  2026-11-11); Postgres pelo podman, uso comentado em `pgadmin.nix`.
- `orange` usa o binário oficial do pixi 0.83.0 até o nixpkgs corrigir.
- Deploy do aspire: `nh os switch ~/nixos-config -H aspire --target-host
  root@aspire.local`. Não há gerenciamento de segredos.

## Custo de atualização

- `.envrc` usa `nix_direnv_manual_reload`; `nix-direnv-reload` ao mudar o
  lock. Após o `cleanup`, o `flake check --no-build` falha até um dry-run
  baixar o esquema do Stylix.
- chaotic, noctalia e umbriel mantêm o nixpkgs próprio (`flake-duplicates`).

## Decisões adiadas

- Host headless: tirar `graphical` da base; dois usuários com temas
  diferentes conflitariam no tema do sistema.

## Próximas ações

1. Apagar sobras em `~` (`.claude`, `.claude.json`, `.nix-profile`,
   `.nix-defexpr`, `.bash_history`, `.pulse-cookie`) e conferir atalhos,
   ZapZap, temas, pgAdmin e `/permissions` do Claude.
2. Ativar o nitro: resolver o blocker, gerar `_hardware.nix`, confirmar os
   bus IDs (`lspci -D`) e renomear `_default.nix` para `default.nix`.
3. No aspire, ver se as prefs VA-API do Firefox em `intel-graphics.nix`
   servem: pôr as duas em `false` no `about:config`, reiniciar e olhar
   `HARDWARE_VIDEO_DECODING` no `about:support` (disponível = remover;
   bloqueado = manter com comentário). Depois avaliar `services.xserver` só
   no LXQt e o grupo `i2c`, e apagar os branches `backup/*`.

## Blockers

Nitro: com `enable32Bit` (Steam), o módulo NVIDIA adiciona EGL i686
(`egl-wayland`, `egl-wayland2`, `egl-gbm`, `eglexternalplatform`, mais
moreutils/perl) fora de cache.nixos.org, nix-community e nyx. Opções:
esperar o cache, aceitar compilar, ou tirar só essas EGL 32 bits.

Nenhum segredo foi adicionado aos arquivos rastreados.
