# HANDOFF

Last updated: 2026-11-04 UTC

## Estado atual

- Hosts:
  - `desktop`: KDE, `desktop-apps`, kernel CachyOS, AMD e secrets via sops.
  - `aspire`: notebook leve com LXQt, Niri, Firefox e Intel; ainda sem secrets,
    por isso usa `git` cru em vez do aspect `git`.
  - `nitro`: rascunho desabilitado até existir o `_hardware.nix` real.
- Home Manager é integrado nos hosts NixOS (`classes = [ "homeManager" ]`); o
  host `template` mostra o caminho standalone para distros sem NixOS.
- `NH_FLAKE` vem do Home Manager e aponta para `~/nixos-config`. O `nh clean`
  semanal usa `--keep-since 7d --keep 3 --keep-one` em todos os hosts.
- O Mango continua existindo de propósito, sem ser incluído por nenhum host.
- `orange` e `brmodelo` são aspects avulsos, sem inclusão em grupo ou perfil.
  O Orange baixa o ambiente Conda via Pixi no primeiro uso, fora do store, e
  ainda não foi testado.
- O RStudio vem do tarball oficial em um FHS runtime, porque o pacote do
  nixpkgs exigia compilação local.
- Os estados anteriores à reconciliação com o remote (2026-11-03) estão nas
  branches `backup/*` e em `stash@{0..2}`.

## Próximas ações

1. Fazer push dos commits locais.
2. Rodar `nh os switch` e relogar, para que o `NH_FLAKE` novo entre em vigor.
3. Depois de validar, apagar as branches `backup/*` e os stashes antigos.

## Blockers

Nenhum. Vencord/Vesktop podem não ter substituto em cache; revisar o dry-run
antes de cada switch.

Nenhum segredo foi adicionado aos arquivos rastreados.
