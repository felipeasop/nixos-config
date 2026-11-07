## Organização

- `environments/` — ambientes completos, como KDE/Plasma e SDDM.
- `session/` — base comum da sessão gráfica: X11 (aspect `graphical`, no
  baseline de host) e portais XDG (aspect `xdg`).
- `theme/` — tema único via Stylix (aspect `stylix`, incluído pelo
  `graphical`); os alvos ligados ficam listados em `stylix.nix`.
- `compositors/` — compositores/window managers: Niri, MangoWM e Umbriel.
- `shells/` — desktop shells, barras e widgets; atualmente somente Noctalia.
- `niri-stack/`, `mango-stack/` e `umbriel-stack/` — bundles de sessão que
  combinam cada compositor com Noctalia e a integração XDG compartilhada.

Niri e Mango ficam habilitados simultaneamente como opções no SDDM; apenas a
sessão escolhida roda. `COSMIC` continua opcional e mínimo.

Os nomes dos aspects refletem os componentes (`niri`, `noctalia`, `xdg`,
`stylix`) e o bundle de cada sessão. O `import-tree` descobre os módulos
automaticamente.
