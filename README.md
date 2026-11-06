# NixOS Config

Meu setup pessoal utilizando Nix seguindo o [padrão dendrítico](https://github.com/mightyiam/dendritic) com o framework [Den](https://den.denful.dev).

### Ferramentas

- [Nix](https://nixos.org) com flakes e [nixpkgs unstable](https://github.com/NixOS/nixpkgs)
- [Den](https://den.denful.dev): Composição por aspects sobre flake-parts
- [import-tree](https://github.com/denful/import-tree): Descoberta automática de módulos
- [flake-file](https://github.com/denful/flake-file): inputs declarados junto aos módulos que os usam e geração do `flake.nix`
- [home-manager](https://github.com/nix-community/home-manager): Configuração declarativa do ambiente dos usuários, integrada em hosts NixOS e standalone em outros sistemas
- [treefmt](https://github.com/numtide/treefmt-nix) + [git-hooks.nix](https://github.com/cachix/git-hooks.nix): Formatação e análise estática automatizadas por hooks do Git
- [nh](https://github.com/nix-community/nh): Interface para avaliar, testar e ativar configurações NixOS
- [chaotic-cx/nyx](https://github.com/chaotic-cx/nyx): Cache binário e kernel CachyOS
