## Organização

- `environments/` — ambientes completos, como KDE/Plasma e SDDM.
- `integration/` — integração comum da sessão gráfica, como portais XDG.
- `compositors/` — compositores/window managers, atualmente Niri.
- `shells/` — desktop shells, barras e widgets, atualmente Noctalia.
- `desktop-stack/` — bundle que combina o compositor, a shell e a integração
  necessários para o perfil gráfico do usuário.

Os nomes dos aspects refletem os componentes (`niri`, `noctalia`, `xdg`) e o
bundle (`desktop-stack`). O `import-tree` descobre os módulos automaticamente.
