## Organização

- `environments/` — ambientes completos, como KDE/Plasma e SDDM.
- `integration/` — integração comum da sessão gráfica, como portais XDG.
- `compositors/` — compositores/window managers, atualmente Niri e MangoWM.
- `shells/` — desktop shells, barras e widgets; atualmente somente Noctalia.
- `desktop-stack/` — bundle que combina o compositor, a shell e a integração
  necessários para o perfil gráfico do usuário.

`MangoWM` e `COSMIC` são aspects opcionais e mínimos: existem para facilitar
um teste ou uma futura troca, mas não fazem parte do `desktop-stack` atual.

Os nomes dos aspects refletem os componentes (`niri`, `noctalia`, `xdg`) e o
bundle (`desktop-stack`). O `import-tree` descobre os módulos automaticamente.
