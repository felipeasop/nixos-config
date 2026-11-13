# HANDOFF

Last updated: 2026-11-12 23:50 UTC

## Estado atual

- `desktop`: KDE e Niri, `desktop-apps` (inclui pgadmin e podman), kernel
  CachyOS, AMD.
- `aspire`: notebook leve com LXQt, Niri, Firefox e Intel.
- `nitro`: rascunho desabilitado; `gpu/nvidia.nix` está vazio, a preencher.
- Padrões em `modules/defaults.nix`: `den.default` (define-user, essential,
  git) e `den.schema.{host,home}.includes`; baseline de host inclui
  `multimedia` e `graphical` (que traz o `stylix`).
- Usuário `flp` em `users/flp/` (`default.nix` e `theme.nix`); também home
  standalone para Nix fora do NixOS.
- nixpkgs em `f4a03c0`; o pixi do nixpkgs não compila nessa revisão
  (`orange` usa o binário oficial do pixi 0.83.0).
- Stylix: `stylix.nix` tem só o mecanismo (`autoEnable = false`, targets
  base). O tema (Everforest dark hard) é do `flp`, que o manda ao host por
  `provides.to-hosts`. Cada target é ligado no aspect dono; o `flatpak` liga
  `gtk.flatpakSupport`. Comparado por `nix-diff`: só saíram temas de apps não
  instalados (chromium, gdu, Vencord, gedit, blender, kde no aspire).
- Candidatos a tema: `catppuccin-frappe`, `tomorrow-night-eighties`,
  `catppuccin-macchiato` (critério: astigmatismo, foco, uso longo).
- Comando `cleanup`: limpeza do Nix pela política semanal, `--optimise`,
  Flatpak e imagens órfãs do Podman. Rodar como usuário, sem `sudo`.
- Terminal: kitty padrão via `xdg-terminal-exec`; foot como segunda opção
  (Super+Shift+Enter no niri e KDE).
- Deploy do aspire pelo desktop: `nh os switch ~/nixos-config -H aspire
  --target-host root@aspire.local` (só chave `hosts/desktop/deploy.pub`).
- Não há gerenciamento de segredos.

## Custo de atualização (máquina limitada)

- `.envrc` usa `nix_direnv_manual_reload`; rodar `nix-direnv-reload` quando
  o lock mudar.
- O Stylix lê o esquema durante a avaliação; depois do `cleanup` o
  `nix flake check --no-build` falha até um dry-run do sistema baixá-lo.
- Inputs transitivos sem uso seguem a raiz; chaotic, noctalia e umbriel
  mantêm o nixpkgs próprio (cache upstream), vigiado pelo `flake-duplicates`.
- Wallpaper e avatar passam por `builtins.path`: só mudam com os assets.

## Decisões adiadas

- Host headless: tirar `graphical` de `den.schema.host.includes` e incluí-lo
  só nos hosts com interface.
- Dois usuários com temas diferentes num host conflitariam no tema do sistema
  (GRUB, console, greeter).

## Próximas ações

1. `nh os switch` e conferir: ZapZap sem assistente, temas (Vesktop, Qt no
   KDE, Flatpak), foot, `podman run` do Postgres no pgAdmin.
2. Quando o nixpkgs corrigir o pixi, voltar o `orange` para `pkgs.pixi`.
3. Avaliar `services.xserver` só no LXQt e o grupo `i2c`; apagar os branches
   `backup/*` depois de validar.

## Blockers

claude-agent-acp (Zed) compila localmente a cada atualização: fora do
cache.nixos.org apesar da licença Apache-2.0; manter, aceitar ou remover.

Nenhum segredo foi adicionado aos arquivos rastreados.
