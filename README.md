# NixOS Config

Personal NixOS configuration built with the
[dendritic pattern](https://github.com/mightyiam/dendritic) and the
[Den](https://den.denful.dev) framework.

Configuração pessoal do NixOS construída com o
[padrão dendrítico](https://github.com/mightyiam/dendritic) e o framework
[Den](https://den.denful.dev).

## English

### Tools

- [Nix](https://nixos.org) with flakes and [nixpkgs unstable](https://github.com/NixOS/nixpkgs)
- [Den](https://den.denful.dev): aspect composition built on flake-parts
- [import-tree](https://github.com/denful/import-tree): automatic module discovery
- [flake-file](https://github.com/denful/flake-file): inputs are declared beside their consumer modules and generate `flake.nix`
- [home-manager](https://github.com/nix-community/home-manager): declarative user-environment configuration
- [treefmt](https://github.com/numtide/treefmt-nix) and [git-hooks.nix](https://github.com/cachix/git-hooks.nix): formatting and static analysis through Git hooks
- [sops-nix](https://github.com/Mic92/sops-nix): declarative management of encrypted secrets
- [nh](https://github.com/nix-community/nh): interface for evaluating, testing, and activating NixOS configurations
- [chaotic-cx/nyx](https://github.com/chaotic-cx/nyx): binary cache and CachyOS kernel

### Commands

```sh
nix run .#write-flake && git add flake.nix && nh os switch . # after changing flake-file.inputs
git add path/to/changed-file.nix && nh os switch .           # day-to-day changes
nh os test .                                                 # test without making it available at boot
nix fmt                                                       # format everything
nix flake check                                               # lint and checks
```

See `AGENTS.md` for conventions and architecture details, and
`secrets/README.md` for secrets.

## Português (Brasil)

Meu setup pessoal utilizando Nix seguindo o [padrão dendrítico](https://github.com/mightyiam/dendritic) com o framework [Den](https://den.denful.dev).

### Ferramentas

- [Nix](https://nixos.org) com flakes e [nixpkgs unstable](https://github.com/NixOS/nixpkgs)
- [Den](https://den.denful.dev): Composição por aspects sobre flake-parts
- [import-tree](https://github.com/denful/import-tree): Descoberta automática de módulos
- [flake-file](https://github.com/denful/flake-file): inputs declarados junto aos módulos que os usam e geração do `flake.nix`
- [home-manager](https://github.com/nix-community/home-manager): Configuração declarativa do ambiente dos usuários
- [treefmt](https://github.com/numtide/treefmt-nix) + [git-hooks.nix](https://github.com/cachix/git-hooks.nix): Formatação e análise estática automatizadas por hooks do Git
- [sops-nix](https://github.com/Mic92/sops-nix): Gerenciamento declarativo de segredos cifrados
- [nh](https://github.com/nix-community/nh): Interface para avaliar, testar e ativar configurações NixOS
- [chaotic-cx/nyx](https://github.com/chaotic-cx/nyx): Cache binário e kernel CachyOS

### Comandos

```sh
nix run .#write-flake && git add flake.nix && nh os switch . # após mudar flake-file.inputs
git add path/to/changed-file.nix && nh os switch .       # dia a dia
nh os test .                                             # testa sem persistir no boot
nix fmt                                                   # formata tudo
nix flake check                                           # lint + checks
```

Convenções e detalhes de arquitetura: ver `AGENTS.md`. Segredos: ver `secrets/README.md`.
