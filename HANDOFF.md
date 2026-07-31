# HANDOFF

Last updated: 2026-07-31 21:16 UTC

## Current State

Investigado e corrigido `error: attribute 'sops' missing` ao rodar
`nh os switch . -u -vvv` após adicionar `apps/dev/git/github-token.nix`
com `den.aspects.git.nixos.sops.secrets...`. Causa: `git` é incluído
só do lado **user** (`flp.includes`), então a classe `nixos` desse
aspect nunca chegava no host `atlas` — `config.sops` não existe nesse
ponto de avaliação porque o aspect `secrets` (dono de `sops.*`) só é
`includes`d em `atlas`, não em `flp`. Confirmado contra a doc oficial
([Host↔User Mutual Providers](https://den.denful.dev/guides/mutual/)):
"No battery required" — cross-entity routing é built-in, sem precisar
de `den._.mutual-provider` (uma nota de changelog antiga sugeria o
contrário; a doc atual, que é a fonte de verdade, contradiz isso).
Fix: `den.aspects.git.provides.to-hosts.nixos = { config, ... }: { ... }`
em vez de `den.aspects.git.nixos = { ... }`. Documentado em `AGENTS.md`
na seção "Padrão oficial: host↔user mutual providers", com regra
prática nova ("quem é dono de um aspect misto") e exemplo canônico do
próprio README do Den.

A partir desse caso, auditados todos os ~35 aspects do repo procurando
o mesmo padrão (aspect com classes `nixos` + `homeManager` ao mesmo
tempo, mas `includes`d só de um lado, sem `provides` cobrindo a classe
minoritária). Resultado da auditoria, arquivos com correção **pronta
mas ainda não escrita no repo** (ver blocos de código na conversa):
- `modules/desktop/kde/default.nix` — dono host (`atlas.includes`);
  faltava `provides.to-users.homeManager` (plasma-manager, mouse
  Logitech, atalho Ghostty).
- `modules/security/keyring.nix` — dono host (`standard-host`);
  faltava `provides.to-users.homeManager.services.gnome-keyring.enable`.
- `modules/desktop/wm/niri/default.nix` — dono user (`flp` → `wm`);
  faltava `provides.to-hosts.nixos` (`programs.niri.enable` nunca
  chegava no host — niri provavelmente não aparecia como sessão no
  SDDM).
- `modules/apps/peripherals/solaar.nix` — dono user (`flp`); faltava
  `provides.to-hosts.nixos.hardware.logitech.wireless` (driver nunca
  ativado no sistema).
- `modules/apps/dev/git/github-token.nix` — arquivo novo (token do
  GitHub pro rate limit da API, via sops + `nix.extraOptions`), mesma
  correção `provides.to-hosts.nixos`, criado durante essa investigação
  mas ainda não escrito em disco.

Não corrigido, só identificado: `modules/apps/fish/default.nix` tem
`nixos.programs.fish.enable = true` que é provavelmente redundante
com a battery `(user-shell "fish")` já incluída via `standard-user`
(que, segundo `AGENTS.md`, "habilita o shell em ambas as classes") —
precisa confirmar isso antes de remover, para não perder
`programs.fish.enable` a nível de sistema sem substituto.

Também avaliada (a pedido do usuário) a hipótese de abandonar o Den e
usar flake-parts + import-tree puro. Decisão: não compensa agora. O
erro que motivou a pergunta não era um bug do Den (ver acima); "file
path independence" vem do `import-tree`, não do Den, então essa
vantagem seria preservada de qualquer forma — mas o roteamento
host↔user automático (`provides.to-hosts`/`to-users`) teria que ser
reimplementado manualmente em ~100 arquivos, reintroduzindo o mesmo
tipo de problema (host↔user routing) sem o mecanismo declarativo.

## Top 3 Next Actions

- Aplicar os 5 arquivos com correção pronta listados acima (comandos
  fish com heredoc já fornecidos na conversa) e rodar
  `nh os switch . -vvv` pra confirmar build limpo antes de commitar.
- Confirmar se `(user-shell "fish")` já cobre `programs.fish.enable`
  a nível `nixos` antes de remover a fatia `nixos` redundante de
  `apps/fish/default.nix`.
- Gerar o secret `github_token` no `secrets/secrets.yaml` via sops
  (formato `access-tokens = github.com=ghp_xxx`, não só o token cru)
  — o arquivo `github-token.nix` já espera essa chave existir.

## Blockers

Nenhum.

---

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

---

Last updated: 2026-07-31 22:39 UTC

## Current State

Resolvido o bloqueio real de boot causado pelo `github-token.nix`
criado na sessão anterior. O `nix-daemon` estava em
`start-limit-hit`: o `nix.conf` gerado (já ativo no sistema, de um
switch anterior) continha `!include /run/secrets/github_token`
apontando direto pro secret cru — que armazena só o token
(`ghp_...`), sem a chave `access-tokens = github.com=...` na frente.
O parser do `nix.conf` não reconhece uma linha sem `chave = valor` e
falha a cada tentativa de start do daemon, inclusive em boot
(`Connection refused` / depois `Connection reset by peer` com o
socket "vivo" mas o daemon morto atrás dele).

Tentativa intermediária de usar `builtins.readFile` no path do
secret para montar `nix.settings.access-tokens` diretamente falhou
com `access to absolute path '/run/secrets/github_token' is
forbidden in pure evaluation mode` — a avaliação da flake roda em
modo puro (sandbox), então `readFile` não pode ler `/run/secrets/*`
em build-time, só o sops-nix consegue popular esse conteúdo, e isso
só acontece em ativação.

Fix definitivo: `sops.templates."nix-github-token.conf"`, que gera
um arquivo com `access-tokens = github.com=${config.sops.placeholder.github_token}`
em ativação (o placeholder é só uma string mágica em build-time, sem
`readFile`; o sops-nix substitui pelo valor real depois). O
`nix.extraOptions` do aspect `git` agora faz `!include` desse
template em vez do secret cru — sintaxe sempre válida, secret nunca
em texto plano no Nix store.

Para destravar o boot já quebrado (sem esperar reboot com generation
antigo), foi usado um bind mount temporário sobre
`/etc/static/nix/nix.conf` com uma cópia do `nix.conf` sem a linha
`!include` quebrada, só o suficiente para reviver o `nix-daemon` e
rodar o switch que aplica o fix declarativo de verdade. O bind mount
foi desfeito após o switch bem-sucedido; o `nix.conf` definitivo
passou a ser gerado normalmente a partir da config corrigida.

Confirmado por `nh os switch . -vvv`: build limpo (13 derivações),
`nix-github-token.conf` aparece como `ADDED` no diff de ativação,
`switch-to-configuration test` e `boot` completados sem erro.

Nenhum segredo foi adicionado a arquivos rastreados — o secret
`github/token` já existia cifrado em `secrets/secrets.yaml`; só o
mecanismo de consumo dele mudou.

## Top 3 Next Actions

- Confirmar se `(user-shell "fish")` já cobre `programs.fish.enable`
  a nível `nixos` antes de remover a fatia `nixos` redundante de
  `apps/fish/default.nix` (pendência já registrada na entrada
  anterior, ainda não resolvida).
- Validar em uso normal que `git` (clone/fetch de repos privados via
  HTTPS, ou qualquer chamada que use o rate limit autenticado da API
  do GitHub) está de fato usando o token novo.
- Nenhuma ação pendente relacionada ao bind mount — já desfeito nesta
  sessão; não deixar esse passo documentado como procedimento padrão,
  era só recuperação pontual de um estado quebrado.

## Blockers

Nenhum.

---

Last updated: 2026-07-31 22:39 UTC

## Current State

Resolvido o bloqueio real de boot causado pelo `github-token.nix`
criado na sessão anterior. O `nix-daemon` estava em
`start-limit-hit`: o `nix.conf` gerado (já ativo no sistema, de um
switch anterior) continha `!include /run/secrets/github_token`
apontando direto pro secret cru — que armazena só o token
(`ghp_...`), sem a chave `access-tokens = github.com=...` na frente.
O parser do `nix.conf` não reconhece uma linha sem `chave = valor` e
falha a cada tentativa de start do daemon, inclusive em boot
(`Connection refused` / depois `Connection reset by peer` com o
socket "vivo" mas o daemon morto atrás dele).

Tentativa intermediária de usar `builtins.readFile` no path do
secret para montar `nix.settings.access-tokens` diretamente falhou
com `access to absolute path '/run/secrets/github_token' is
forbidden in pure evaluation mode` — a avaliação da flake roda em
modo puro (sandbox), então `readFile` não pode ler `/run/secrets/*`
em build-time, só o sops-nix consegue popular esse conteúdo, e isso
só acontece em ativação.

Fix definitivo: `sops.templates."nix-github-token.conf"`, que gera
um arquivo com `access-tokens = github.com=${config.sops.placeholder.github_token}`
em ativação (o placeholder é só uma string mágica em build-time, sem
`readFile`; o sops-nix substitui pelo valor real depois). O
`nix.extraOptions` do aspect `git` agora faz `!include` desse
template em vez do secret cru — sintaxe sempre válida, secret nunca
em texto plano no Nix store.

Para destravar o boot já quebrado (sem esperar reboot com generation
antigo), foi usado um bind mount temporário sobre
`/etc/static/nix/nix.conf` com uma cópia do `nix.conf` sem a linha
`!include` quebrada, só o suficiente para reviver o `nix-daemon` e
rodar o switch que aplica o fix declarativo de verdade. O bind mount
foi desfeito após o switch bem-sucedido; o `nix.conf` definitivo
passou a ser gerado normalmente a partir da config corrigida.

Confirmado por `nh os switch . -vvv`: build limpo (13 derivações),
`nix-github-token.conf` aparece como `ADDED` no diff de ativação,
`switch-to-configuration test` e `boot` completados sem erro.

Nenhum segredo foi adicionado a arquivos rastreados — o secret
`github/token` já existia cifrado em `secrets/secrets.yaml`; só o
mecanismo de consumo dele mudou.

Nos commits que seguiram, o histórico foi reorganizado (via
`git reset --soft` + recommits) pra separar o fix do github-token dos
outros achados da auditoria de mutual providers (kde, niri, keyring,
solaar, fish), cada tema em commit próprio, docs por último.

## Top 3 Next Actions

- Confirmar se `(user-shell "fish")` já cobre `programs.fish.enable`
  a nível `nixos` antes de remover a fatia `nixos` redundante de
  `apps/fish/default.nix` (pendência já registrada na entrada
  anterior, ainda não resolvida).
- Validar em uso normal que `git` (clone/fetch de repos privados via
  HTTPS, ou qualquer chamada que use o rate limit autenticado da API
  do GitHub) está de fato usando o token novo.
- Nenhuma ação pendente relacionada ao bind mount — já desfeito nesta
  sessão; não deixar esse passo documentado como procedimento padrão,
  era só recuperação pontual de um estado quebrado.

## Blockers

Nenhum.

---

Last updated: 2026-07-31 23:07 UTC

## Current State

`AGENTS.md` enxugado pra remover redundância e conteúdo desatualizado.
A seção "Build e deploy" duplicava quase 1:1 a seção "Comandos" do
`README.md` — removida, agora só aponta pra lá. A seção "Ferramentas
do dia a dia (fish functions)" listava `rebuild`, `rebuild-test`,
`rebuild-update` e `rebuild-with-new-inputs` — nenhuma dessas existe
mais em `modules/apps/fish/functions.nix`; o usuário já tinha removido
todas manualmente, restando só `write-flake` (regenera `flake.nix`,
já dá `git add -A` e mostra o diff cacheado pra revisão antes de
commitar) mais os utilitários de shell pré-existentes (histórico com
`!`, `backup`, `copy`). A seção foi reescrita pra refletir isso.

Adotado `jj` (Jujutsu) como front-end **prioritário** sobre `git` puro
pra todo trabalho de versionamento neste repo daqui pra frente —
decisão do usuário, documentada numa seção própria em `AGENTS.md`
("Controle de versão: `jj` tem prioridade sobre `git`"). A seção
anterior tinha uma referência quebrada a "seção Build e deploy acima"
(que não existe mais) e citava `rebuild`/`rebuild-test` como exemplo
de comandos `git` ainda não portados — ambos corrigidos: a referência
cruzada foi trocada por uma explicação de que `git add -A` citado na
seção "flake.nix é gerado" descreve o mecanismo do import-tree
(arquivo precisa estar rastreado), não uma instrução de usar `git` em
vez de `jj` — em `jj` o equivalente é só ter o arquivo no working
copy, sem precisar de `jj add`. `jj` opera sobre o mesmo `.git` já
existente; nenhuma migração de repositório foi feita.

Sessão anterior explorou uma função fish combinada (`os
switch/test/boot` com flags combináveis pra verbose, update, flake,
dry-run, ask) mas foi descartada por complexidade desproporcional ao
ganho — decisão consciente do usuário de manter `write-flake` como
única função fish "de fluxo", chamando `nh`/`jj` diretamente pra
qualquer outra coisa.

## Top 3 Next Actions

- Confirmar se `(user-shell "fish")` já cobre `programs.fish.enable`
  a nível `nixos` antes de remover a fatia `nixos` redundante de
  `apps/fish/default.nix` (pendência antiga, ainda não resolvida).
- Migrar o fluxo de commit real do usuário pra `jj` na próxima sessão
  em que houver mudanças a commitar — a decisão foi documentada, mas
  ainda não exercitada na prática neste repo.
- Validar em uso normal que `git`/`jj` (clone/fetch de repos privados
  via HTTPS, ou qualquer chamada que use o rate limit autenticado da
  API do GitHub) está de fato usando o token novo do github-token.nix.

## Blockers

Nenhum.
