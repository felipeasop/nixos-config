# HANDOFF

Last updated: 2026-11-07 01:08 UTC

## Estado atual

- `desktop`: KDE (sem KDE PIM e Discover) e Niri, `desktop-apps`, kernel
  CachyOS e AMD.
- `aspire`: notebook leve com LXQt, Niri, Firefox e Intel.
- `nitro`: rascunho desabilitado até existir o `_hardware.nix` real.
- `template`: exemplo inativo de home standalone para distros sem NixOS.
- Baseline de host: `essential`, `audio`, `graphical` (X11, inclui o aspect
  `stylix`), `git`, `admin-tools`, `unrar`, `security`, `kernel`,
  `kernel-tuning` e `flatpak`.
- Stylix é o dono do tema (Everforest, fontes e cursor), em
  `modules/desktop/theme/stylix.nix`, que lista os alvos ligados para
  desligar por app. O Noctalia usa a paleta dele e só mantém o template do
  Prism Launcher, que o Stylix não cobre. Overlays e o alvo GNOME estão
  desligados porque recompilariam pacotes.
- Apps com módulo no Home Manager usam `programs.<app>`; o Obsidian tem o
  cofre `~/Documentos/Obsidian Vault` declarado para o Stylix temá-lo.
- Caches binários ficam no arquivo do aspect que os usa, registrados no
  `essential`; o `bootstrap.sh` os passa ao primeiro build de uma instalação.
- Mango e Umbriel (`umbriel-stack`) existem como sessões disponíveis, sem
  inclusão em host; o Orange entra pelo `desktop-apps` e não foi testado.
- Não há gerenciamento de segredos; chaves SSH são criadas à mão.

## Próximas ações

1. Rodar `nh os switch ~/nixos-config` e conferir Obsidian (appearance.json
   antigo vira `.hm-bak`), Prism, tmux, micro e os aliases do eza.
2. Avaliar se `services.xserver` deve sair do `graphical` e ficar só no
   LXQt, já que o desktop roda KDE e Niri em Wayland.
3. Fazer push e apagar `backup/pre-reorganize-2026-11-06` depois de validar.

## Blockers

Nenhum.

Nenhum segredo foi adicionado aos arquivos rastreados.
