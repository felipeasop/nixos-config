# MangoWM

Esta configuração adapta a experiência do Niri ao Mango 0.16.3 disponível no
`nixpkgs` pinado. Ela é instalada pelo Home Manager e validada com:

```sh
mango -c modules/desktop/compositors/mango/config/config.conf -p
```

O módulo NixOS `programs.mango` registra a sessão **Mango** no SDDM e configura
os portais GTK/WLR. O `mango-stack` combina o compositor com `noctalia` e
`xdg`; escolher Niri ou Mango na tela de login não altera os arquivos pessoais
nem exige trocar a configuração.

## Integração com Noctalia

Noctalia v5 reconhece Mango como compositor nativo pelo
`MANGO_INSTANCE_SIGNATURE` ou por `XDG_CURRENT_DESKTOP=mango`. Seu backend Mango
acompanha tags, janelas, monitor ativo e layout de teclado via IPC.

Mango não importa sozinho todas as variáveis da sessão no gerenciador systemd
do usuário. Por isso `mango-session-ready`, chamado por `exec-once`, importa o
ambiente para systemd/DBus e reinicia `noctalia.service`. O serviço possui
condições alternativas para Niri e Mango, portanto não inicia na sessão Plasma.

Fontes oficiais:

- <https://github.com/noctalia-dev/noctalia#wayland-compositor-support>
- <https://github.com/mangowm/mango/blob/main/docs/configuration/basics.md>
- <https://github.com/mangowm/mango/blob/main/docs/bindings/keys.md>

## Diferenças inevitáveis em relação ao Niri

| Recurso do Niri | Adaptação no Mango |
| --- | --- |
| Workspaces verticais, dinâmicos e por monitor | Mango usa nove tags. J/K e setas navegam para a tag adjacente quando não há janela naquela direção. |
| Tiling scrollável por colunas | O layout `scroller` preserva larguras de 1/3, 1/2 e 2/3, mas pilhas e foco não têm exatamente a mesma geometria do Niri. |
| Mover uma janela para um workspace novo entre dois existentes | Sem equivalente completo: `view_insert` cria/abre uma tag vazia, mas o modelo fixo de tags não preserva a mesma semântica dinâmica. Os atalhos não foram simulados. |
| Aumentar/diminuir largura em 10% | Mango só expõe proporção absoluta ou ciclo de presets. `Super+-` seleciona 1/3, `Super+=` seleciona 2/3 e `Super+R` percorre os presets. |
| Maximizar/centralizar coluna e ajustar altura tiled | Sem equivalência geométrica. `Super+Shift+F` mantém fullscreen; não foram atribuídos atalhos enganosos a operações diferentes. |
| Overlay nativo de atalhos | Mango não oferece um overlay equivalente. |
| Captura nativa | `mango-screenshot` usa `grim`, `slurp`, `mmsg` e `wl-copy`; salva em `Pictures/Screenshots` e copia para o clipboard. |
| Molas e curvas por tipo de movimento | Mango usa animações globais de duração/curva; foram mantidos 200 ms para abrir, fechar e mover. |
| Cantos e recorte configurados por janela | Mango aplica raio global de 8 px. |
| Steam toast fixado a 10 px do canto inferior direito | Mango só oferece offsets percentuais para janelas flutuantes; o posicionamento foi omitido. |
| `place-within-backdrop` para o wallpaper do Noctalia | Não há controle de colocação equivalente em layer rules; o layer continua renderizado, apenas sem essa garantia adicional. |
| Alternar inibição de atalhos | Mango não expõe dispatcher equivalente. |

## Atalhos principais

- `Super+Enter`: Ghostty
- `Super+D`: launcher do Noctalia
- `Super+S`: central de controle
- `Alt+Tab`: alternador de janelas do Noctalia
- `Super+H/J/K/L` ou setas: foco
- `Super+Ctrl+H/J/K/L` ou setas: mover/trocar janela
- `Super+1..9`: selecionar tag
- `Super+Ctrl+1..9`: mover janela para tag
- `Super+O` ou `Super+W`: overview do Mango
- `Print`, `Alt+Print`, `Ctrl+Print`: região, janela e tela inteira
- `Ctrl+Alt+Delete`: encerrar a sessão Mango

O arquivo `outputs.conf` permanece automático. Regras de monitor só devem ser
adicionadas depois de confirmar os nomes e modos reais dentro da sessão com
`mmsg get monitors` ou `wlr-randr`; inventar `eDP-1` tornaria o primeiro teste
menos seguro.
