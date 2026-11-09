# desktop

O que monta uma sessão gráfica: ambientes, compositores, shells e os bundles
que os combinam. A base comum (X11 e tema) fica em `modules/features/`.

- `environments/`: ambientes completos (KDE, LXQt, COSMIC); os maiores ficam
  divididos em arquivos por assunto, como o niri.
- `compositors/`: compositores (Niri, Umbriel).
- `shells/`: barra, widgets e lockscreen (Noctalia).
- `stacks/`: bundles de sessão, compositor + Noctalia + `xdg-portals`.
- `xdg-portals.nix`: portais XDG, incluídos pelos stacks.
