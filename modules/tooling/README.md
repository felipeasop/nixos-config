# tooling

Ferramentas do repositório, não do sistema: formatador (`nix fmt`, nixfmt no
modo padrão, como no nixpkgs), análise estática e hooks de pre-commit.

- `pre-commit.nix`: hooks `treefmt`, `deadnix`, `statix`, `nix-style` e
  `commit-msg-style`. O `nix-style` usa ast-grep e exige atribuições
  agrupadas por prefixo e cada classe (`nixos`, `homeManager`) num bloco
  próprio, com cabeçalho numa linha e corpo expandido; ele só aponta, não
  corrige.
