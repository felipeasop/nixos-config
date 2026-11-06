# HANDOFF

Last updated: 2026-11-06 03:45 UTC

## Estado atual

- `desktop`: KDE (sem KDE PIM e Discover) e Niri, `desktop-apps`, kernel
  CachyOS e AMD.
- `aspire`: notebook leve com LXQt, Niri, Firefox e Intel.
- `nitro`: rascunho desabilitado até existir o `_hardware.nix` real.
- `template`: exemplo inativo de home standalone para distros sem NixOS.
- Baseline de host: `essential`, `audio`, `graphical` (X11 e Stylix),
  `git`, `admin-tools`, `unrar`, `security`, `kernel`, `kernel-tuning`
  e `flatpak`.
- Stylix é o dono do tema (Everforest, fontes e cursor); o Noctalia usa a
  paleta dele. Overlays e o alvo GNOME estão desligados porque recompilariam
  pacotes.
- Caches binários ficam no arquivo do aspect que os usa, registrados no
  `essential`; o `bootstrap.sh` os passa ao primeiro build de uma instalação.
- Mango e Umbriel (`umbriel-stack`) existem como sessões disponíveis, sem
  inclusão em host; o Orange entra pelo `desktop-apps` e não foi testado.
- Não há gerenciamento de segredos; chaves SSH são criadas à mão.

## Próximas ações

1. Rodar `nh os switch ~/nixos-config`, reiniciar o Zed e conferir o tema no
   KDE, no Niri e, no aspire, no LXQt (Qt via qtct/Kvantum).
2. Decidir em quais hosts incluir o `umbriel-stack`.
3. Fazer push e apagar `backup/pre-reorganize-2026-11-06` depois de validar.

## Blockers

Nenhum.

Nenhum segredo foi adicionado aos arquivos rastreados.
