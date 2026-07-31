# HANDOFF

Last updated: 2026-07-31 23:30 UTC

## Current State

Aspects que instalavam apps de usuário único via classe `nixos`
(vazando o pacote pra qualquer usuário do host em vez de ficar isolado
no perfil do `flp`) foram corrigidos para `homeManager`. Afetados:
`modules/apps/gaming/r2modman.nix` e `modules/apps/gaming/proton.nix`
(protonup-qt), ambos agora só `homeManager.home.packages`.
`modules/apps/peripherals/solaar.nix` foi separado em dois blocos: o
pacote (`homeManager.home.packages`) e o driver de hardware Logitech
(`nixos.hardware.logitech.wireless`, que permanece `nixos` porque é
config real de driver/kernel, não de usuário). `modules/apps/dev/cli-tools.nix`
foi avaliado e mantido em `nixos.environment.systemPackages` de
propósito — decisão consciente de que essas ferramentas (ripgrep, fzf,
htop, jq etc.) devem estar disponíveis a qualquer usuário do host,
mesmo fora de sessão gráfica, não só ao `flp`. `hosts/atlas/default.nix`
e `users/flp.nix` foram revisados e confirmados corretos sem alteração
— identities e essential já chegam ao user via `provides.to-users`,
como documentado em `AGENTS.md`. `fish` permanece incluído só em
`flp.nix` (não subiu pro host): decisão consciente do usuário de que a
config de shell é opinativa/pessoal, mesmo sendo o único usuário do
host hoje. Todos os 100 arquivos `.nix` do repo foram auditados por
inversão de classe (`nixos` vs `homeManager`); nenhum outro caso
pendente foi encontrado. `AGENTS.md` foi reestruturado no molde do
repo `llego/nixconfig` (bloco de workflow de sessão no topo: ordem de
leitura, disciplina de atualização de `HANDOFF.md`, checklist de fim de
sessão), preservando todo o conteúdo técnico específico deste repo
(framework/terminologia, convenções de pasta, identity flags, mutual
providers, segredos, fish functions) na seção "Arquitetura" abaixo do
workflow. `HANDOFF.md` foi criado pela primeira vez, com este resumo.
Nenhum segredo foi adicionado a arquivos rastreados.

Foi discutida (mas não aplicada) a possibilidade de configurar KDE via
`home-manager` usando `plasma-manager` (nix-community), pra declarar
aceleração de mouse, atalhos e tema em vez de deixar só na GUI. Padrão
sugerido: `modules/desktop/kde/default.nix` mantém `nixos` (sddm,
plasma6) + `homeManager.programs.plasma.enable` como base neutra;
personalização (mouse, tema, atalhos) ficaria num aspect separado
(`kde-personal`, sem parametrizar por usuário — decisão consciente,
dado que o repo é de usuário único). Rodou-se `rc2nix` uma vez pra
capturar a config atual do KDE; a maior parte do output é ruído
(atalhos default do Plasma, UUIDs de activity/desktop, estado de
sessão do Kate) e não deveria ser declarada. O nome do mouse confirmado
via `kcminputrc` é `"Logitech USB Receiver Mouse"` (ID libinput
1133/50504), com `PointerAccelerationProfile = 1` (mapeia para
`accelerationProfile = "flat"` no plasma-manager — mapeamento não
verificado contra a doc do módulo `input`, checar antes de aplicar).
Isso ainda não foi implementado no repo.

## Top 3 Next Actions

- Se for implementar KDE via home-manager: adicionar `flake-file.inputs.plasma-manager`
  em `modules/desktop/kde/default.nix`, confirmar o mapeamento de
  `accelerationProfile` na doc do plasma-manager antes de aplicar, e
  criar `modules/desktop/kde/personalization.nix` só com o que é
  preferência real (não ruído do `rc2nix`).
- Rodar `nix run .#write-flake && git add -A` se/quando o input do
  plasma-manager for adicionado, antes do próximo rebuild.
- Considerar renomear `modules/flake-file/inputs.nix` para algo mais
  explícito (ex: `framework.nix`), já que hoje concentra só os inputs
  de bootstrap do framework (den, flake-parts, nixpkgs, import-tree,
  home-manager, treefmt-nix, git-hooks), não inputs de app — discutido
  mas não decidido/aplicado.

## Blockers
