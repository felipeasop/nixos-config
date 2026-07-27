# NixOS Config

Minha configuração NixOS usando o [padrão dendrítico](https://github.com/mightyiam/dendritic) com o framework [Den](https://den.denful.dev).

## Estrutura

- `modules/apps/` — software instalável, igual em qualquer contexto
- `modules/features/` — capacidades de sistema reutilizáveis
- `modules/identities/` — combina apps+features num papel de host/user
- `modules/hosts/<nome>/` — config por máquina; `template/` documenta como criar uma nova
- `modules/users/` — config por usuário (home-manager); `standard-user.nix` é a infra base
- `modules/flake-file.nix`, `modules/flake-parts/pkgs.nix` — inputs de flake e config do próprio flake (gerado, ver abaixo)
- `pkgs/by-name/` — pacotes locais fora do nixpkgs

Detalhes de convenção pra quem for mexer no repo: ver `AGENTS.md`.

## Comandos comuns

```sh
sudo nixos-rebuild switch --flake .#<host>
nix fmt                    # formata tudo (treefmt)
nix flake check            # lint + checks
nix run .#write-flake      # regenera flake.nix a partir dos flake-file.inputs
nix develop .#<linguagem>  # devshell (c, java, go, rust, python, ou default combinado)
```

`flake.nix` é gerado automaticamente e não deve ser editado à mão —
inputs de flake são declarados perto do módulo que os usa via
`flake-file.inputs`.
