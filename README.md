# NixOS Config

Minha configuração NixOS usando o [padrão dendrítico](https://github.com/mightyiam/dendritic) com o framework [Den](https://den.denful.dev).

## Ferramentas

- [Nix](https://nixos.org) (flakes) + [nixpkgs unstable](https://github.com/NixOS/nixpkgs)
- [Den](https://den.denful.dev) — composição por aspects sobre flake-parts
- [import-tree](https://github.com/denful/import-tree) — descoberta automática de módulos
- [flake-file](https://github.com/denful/flake-file) — `flake.nix` gerado a partir de inputs declarados junto ao módulo que os usa
- [home-manager](https://github.com/nix-community/home-manager)
- [treefmt](https://github.com/numtide/treefmt-nix) + [git-hooks.nix](https://github.com/cachix/git-hooks.nix) — formatação e lint (`nixfmt`, `deadnix`, `statix`, `shfmt`)
- [sops-nix](https://github.com/Mic92/sops-nix) — segredos cifrados
- [nh](https://github.com/nix-community/nh) — CLI de rebuild
- [chaotic-cx/nyx](https://github.com/chaotic-cx/nyx) — kernel CachyOS

## Comandos

```sh
nix run .#write-flake && git add -A && nh os switch .   # após mudar flake-file.inputs
git add -A && nh os switch .                             # dia a dia
nh os test .                                             # testa sem persistir no boot
nix fmt                                                   # formata tudo
nix flake check                                           # lint + checks
nix develop .#<c|java|go|rust|python>                     # devshell
```

Convenções e detalhes de arquitetura: ver `AGENTS.md`. Segredos: ver `secrets/README.md`.
