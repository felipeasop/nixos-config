# HANDOFF

Last updated: 2026-11-12 01:30 UTC

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
- Avisos do Stylix (rofi, qt no KDE) e do Noctalia corrigidos; `orange` usa o
  binário oficial do pixi 0.83.0; vesktop sem Vencord do sistema (vem do
  cache, com autoUpdate do Vencord); `xwayland.defaultFontPath = ""`;
  `multimedia`; regra `programs.*` no AGENTS.
- Terminal: kitty nos dois hosts (bundle `dev`), padrão via `xdg-terminal-exec`;
  os atalhos do niri, KDE e LXQt chamam `xdg-terminal-exec`. LXQt Wayland
  (labwc) avaliado como próxima etapa possível, ainda não feito.
- Deploy remoto do aspire pelo desktop como root, como nos tutoriais do
  nix.dev: só o aspire aceita root por SSH (`prohibit-password`) e só com a
  chave `hosts/desktop/deploy.pub`. Comando: `nh os switch
  ~/nixos-config -H aspire --target-host root@aspire.local`. Exige um switch
  local no aspire antes. Em todos os hosts só valem chaves declaradas no Nix
  (`authorizedKeysInHomedir = false`). Nomes via avahi (`<host>.local`); a
  chave do host aspire fica fixada no desktop (`hosts/aspire/ssh_host_ed25519_key.pub`).
- Não há gerenciamento de segredos.

## Custo de atualização (máquina limitada)

- `.envrc` usa `nix_direnv_manual_reload`: mudanças no lock não recarregam o
  dev shell sozinhas; rodar `nix-direnv-reload` quando quiser.
- O nil no Zed tem `autoArchive = false`, para não baixar todos os inputs em
  paralelo ao direnv.
- Inputs transitivos sem uso nesta config seguem a raiz: `niri/nixpkgs-stable`,
  `nixcord/{nixpkgs-ci,nixpkgs-packages,home-manager,treefmt-nix}`,
  `stylix/flake-parts` e `chaotic/home-manager`. Chaotic, noctalia e umbriel
  mantêm o nixpkgs próprio (cache upstream).
- Hook `flake-duplicates` (`tooling/flake-duplicates.nix`): barra o commit
  quando o `flake.lock` repete um projeto sem `follows` nem exceção em
  `flake-duplicates.allowed`, declarada no módulo do input.
- Wallpaper e avatar passam por `builtins.path` sobre `inputs.self`: o store
  path depende só do asset, então commits que não mexem nos assets não mudam
  as gerações.

## Próximas ações

1. Rodar `nh os switch ~/nixos-config` (cria a entrada de boot); conferir
   Orange, Vesktop (plugins do Vencord), tema Qt no KDE, wallpaper, avatar e
   kitty pelos atalhos;
   depois `nix-direnv-reload`.
2. Quando o nixpkgs corrigir o pixi, voltar o `orange` para `pkgs.pixi`.
3. Avaliar `services.xserver` só no LXQt e o grupo `i2c`; apagar os branches
   `backup/*` depois de validar.

## Blockers

claude-agent-acp (Zed) compila localmente a cada atualização: fora do
cache.nixos.org apesar da licença Apache-2.0; manter, aceitar ou remover.

Nenhum segredo foi adicionado aos arquivos rastreados.
