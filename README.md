# NixOS Config

Meu setup pessoal utilizando Nix seguindo o [padrão dendrítico](https://github.com/mightyiam/dendritic) com o framework [Den](https://den.denful.dev).

## Ferramentas

- [Nix](https://nixos.org):
- [Flakes]
- [nixpkgs unstable](https://github.com/NixOS/nixpkgs): Channel principal
- [Den](https://den.denful.dev): Composição por aspects sobre flake-parts
- [import-tree](https://github.com/denful/import-tree): Descoberta automática de módulos
- [flake-file](https://github.com/denful/flake-file): Permite distribuir os inputs do flake, neste caso declarados juntos ao módulo que os usa
- [home-manager](https://github.com/nix-community/home-manager): Configuração declarativa do ambiente dos usuários
- [treefmt](https://github.com/numtide/treefmt-nix) + [git-hooks.nix](https://github.com/cachix/git-hooks.nix): Formatação e análise estática automatizadas por hooks do Git
- [sops-nix](https://github.com/Mic92/sops-nix): Gerenciamento declarativo de segredos cifrados
- [nh](https://github.com/nix-community/nh): Interface para avaliar, testar e ativar configurações NixOS
- [chaotic-cx/nyx](https://github.com/chaotic-cx/nyx): Cache binário e kernel CachyOS

## Comandos

```sh
nix run .#write-flake && git add flake.nix && nh os switch . # após mudar flake-file.inputs
git add path/to/changed-file.nix && nh os switch .       # dia a dia
nh os test .                                             # testa sem persistir no boot
nix fmt                                                   # formata tudo
nix flake check                                           # lint + checks
```

Convenções e detalhes de arquitetura: ver `AGENTS.md`. Segredos: ver `secrets/README.md`.
