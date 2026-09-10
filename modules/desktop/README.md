## Organização

- `environments/` — ambientes completos, como KDE/Plasma e SDDM.
- `integration/` — integração comum da sessão gráfica, como portais XDG.
- `compositors/` — compositores/window managers, atualmente Niri e MangoWM.
- `shells/` — desktop shells, barras e widgets; atualmente somente Noctalia.
- `niri-stack/` e `mango-stack/` — bundles de sessão que combinam cada
  compositor com Noctalia e a integração XDG compartilhada.

Niri e Mango ficam habilitados simultaneamente como opções no SDDM; apenas a
sessão escolhida roda. `COSMIC` continua opcional e mínimo.

Os nomes dos aspects refletem os componentes (`niri`, `noctalia`, `xdg`) e o
bundle de cada sessão. O `import-tree` descobre os módulos automaticamente.
