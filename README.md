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
- [home-manager](https://github.com/nix-community/home-manager): declarative user-environment configuration, integrated on NixOS hosts and standalone elsewhere
- [treefmt](https://github.com/numtide/treefmt-nix) and [git-hooks.nix](https://github.com/cachix/git-hooks.nix): formatting and static analysis through Git hooks
- [sops-nix](https://github.com/Mic92/sops-nix): declarative management of encrypted secrets
- [nh](https://github.com/nix-community/nh): interface for evaluating, testing, and activating NixOS configurations
- [chaotic-cx/nyx](https://github.com/chaotic-cx/nyx): binary cache and CachyOS kernel

## Português (Brasil)

Meu setup pessoal utilizando Nix seguindo o [padrão dendrítico](https://github.com/mightyiam/dendritic) com o framework [Den](https://den.denful.dev).

### Ferramentas

- [Nix](https://nixos.org) com flakes e [nixpkgs unstable](https://github.com/NixOS/nixpkgs)
- [Den](https://den.denful.dev): Composição por aspects sobre flake-parts
- [import-tree](https://github.com/denful/import-tree): Descoberta automática de módulos
- [flake-file](https://github.com/denful/flake-file): inputs declarados junto aos módulos que os usam e geração do `flake.nix`
- [home-manager](https://github.com/nix-community/home-manager): Configuração declarativa do ambiente dos usuários, integrada em hosts NixOS e standalone em outros sistemas
- [treefmt](https://github.com/numtide/treefmt-nix) + [git-hooks.nix](https://github.com/cachix/git-hooks.nix): Formatação e análise estática automatizadas por hooks do Git
- [sops-nix](https://github.com/Mic92/sops-nix): Gerenciamento declarativo de segredos cifrados
- [nh](https://github.com/nix-community/nh): Interface para avaliar, testar e ativar configurações NixOS
- [chaotic-cx/nyx](https://github.com/chaotic-cx/nyx): Cache binário e kernel CachyOS
