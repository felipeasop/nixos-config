# HANDOFF

Last updated: 2026-11-10 00:11 UTC

## Estado atual

- `desktop`: KDE e Niri, `desktop-apps`, kernel CachyOS, AMD.
- `aspire`: notebook leve com LXQt, Niri, Firefox e Intel.
- `nitro`: rascunho desabilitado; `gpu/nvidia.nix` está vazio, a preencher.
- Padrões em `modules/defaults.nix`: `den.default` (define-user, essential,
  git) e `den.schema.{host,home}.includes`; baseline de host agora inclui
  `multimedia` (bundle dos aspects `ffmpeg` e `vlc`).
- Home standalone `flp` (Nix fora do NixOS) declarado em `users/flp.nix`.
- nixpkgs em `f4a03c0` (commit `d9b50f7`); o pixi do nixpkgs não compila nessa
  revisão. `/run/current-system` já aponta para `f4a03c0`, mas o perfil de
  boot segue na geração 109 (`0bb2eed`).
- Nesta sessão: avisos do Stylix (rofi, qt no KDE) e do Noctalia corrigidos;
  `orange` usa o binário oficial do pixi 0.83.0; vesktop sem Vencord do
  sistema (vem do cache, com autoUpdate do Vencord);
  `xwayland.defaultFontPath = ""`; `multimedia`; regra `programs.*` no AGENTS.
- Dry-run: `desktop` e `aspire` não compilam nada além de wrappers e config;
  sem avisos de avaliação; config do Noctalia válida.
- Não há gerenciamento de segredos.

## Próximas ações

1. Rodar `nh os switch ~/nixos-config` (cria a entrada de boot);
   conferir Orange, Vesktop (plugins do Vencord) e tema Qt no KDE.
2. Quando o nixpkgs corrigir o pixi, voltar o `orange` para `pkgs.pixi`.
3. Avaliar `services.xserver` só no LXQt e o grupo `i2c`; apagar os branches
   `backup/*` depois de validar.

## Blockers

claude-agent-acp (Zed) compila localmente a cada atualização: fora do
cache.nixos.org apesar da licença Apache-2.0; manter, aceitar ou remover.

Nenhum segredo foi adicionado aos arquivos rastreados.
