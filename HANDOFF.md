# HANDOFF

Last updated: 2026-11-09 03:47 UTC

## Estado atual

- `desktop`: KDE e Niri, `desktop-apps`, kernel CachyOS, AMD.
- `aspire`: notebook leve com LXQt, Niri, Firefox e Intel.
- `nitro`: rascunho desabilitado; `gpu/nvidia.nix` está vazio, a preencher.
- Padrões em `modules/defaults.nix`: `den.default` (define-user, essential,
  git) e `den.schema.{host,home}.includes`. Shell e `primary-user` ficam no
  `users/flp.nix`. O Den é importado em `modules/flake/inputs.nix`.
- Home standalone `flp` (Nix fora do NixOS) declarado em `users/flp.nix`.
- Stylix em `features/stylix.nix` (hosts e homes); Noctalia só mantém o
  template do Prism. nixfmt no modo padrão; o hook `nix-style` (ast-grep)
  exige prefixos agrupados e classes em bloco próprio.
- Pastas reorganizadas: regra de nomes no AGENTS.md; niri, noctalia, kde,
  lxqt e zed-editor divididos por seção. Mango removido.
- Nada commitado desde `9c13c02`; todo o trabalho está fora do stage.
- Não há gerenciamento de segredos.

## Próximas ações

1. Commitar pelo plano da conversa (flakes ignoram arquivos fora do git), rodar
   `nh os switch ~/nixos-config`, conferir avatar no SDDM, Obsidian, Prism
   (tema Matugen), eza e brilho; `direnv reload` para o hook novo.
2. Avaliar `services.xserver` só no LXQt e o grupo `i2c` (uaccess já cobre).
3. Decidir sobre o realce do Den no Zed (protótipo no scratchpad) e as cores
   de destaque; apagar os branches `backup/*` depois de validar.

## Blockers

Compilam localmente a cada atualização: xwayland (módulo do NixOS), vesktop e
vencord (nixcord), claude-agent-acp (depende de claude-code, unfree) e pixi
(fora do cache nesta revisão).

Nenhum segredo foi adicionado aos arquivos rastreados.
