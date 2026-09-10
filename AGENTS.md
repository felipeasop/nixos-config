# AGENTS

## Workflow para agentes

### Início de sessão

Ler nesta ordem:

1. `README.md`
1. `HANDOFF.md`

### Durante o trabalho

- Manter `HANDOFF.md` alinhado com o estado atual e próximas ações.
- Registrar decisões de arquitetura duráveis neste arquivo (`AGENTS.md`),
  mantendo-as enxutas e estáveis — não em `HANDOFF.md`, que é efêmero.
- Atualizar `HANDOFF.md` no meio da sessão se uma decisão significativa for tomada.
- Em commits, incluir um subject curto mais um corpo que explica o
  propósito da mudança e o resultado pro usuário/sistema, não só quais
  arquivos mudaram.

### Fim de sessão

- Atualizar `HANDOFF.md`:
  - timestamp `Last updated` (`YYYY-MM-DD HH:MM UTC`)
  - estado atual
  - top 3 próximas ações
  - blockers (se houver)
  - confirmar que nenhum segredo foi adicionado a arquivos rastreados
- Não atualizar `HANDOFF.md` para mudanças menores ou de documentação.

Comandos de build/deploy: ver `README.md`.

## Convenção de commits

Usar Conventional Commits em português, no formato
`tipo(escopo): resumo no imperativo`. O escopo é opcional quando não melhora a
clareza. Tipos usuais: `feat`, `fix`, `refactor`, `chore` e `docs`.

Todo commit deve ter subject curto e corpo em português: o corpo explica o
propósito da mudança e o resultado para o usuário ou sistema, não apenas os
arquivos alterados. Separar mudanças de responsabilidades distintas em commits
independentes e adicionar ao índice somente os paths de cada grupo.

## Arquitetura

Contexto pra IA (ou humano) mexer nesse repo sem quebrar convenções.
Fontes oficiais citadas ao longo do documento: [padrão dendrítico](https://github.com/mightyiam/dendritic),
[Den — Core Principles](https://den.denful.dev/explanation/core-principles/),
[Den — Batteries](https://den.denful.dev/reference/batteries/),
[Den — Mutual Providers](https://den.denful.dev/guides/mutual/).

## Framework e terminologia oficial

Este repo segue o [padrão dendrítico](https://github.com/mightyiam/dendritic):
todo arquivo `.nix`, exceto `flake.nix`, é um módulo do sistema de módulos
do Nixpkgs, importado automaticamente na configuração de topo. Path de
arquivo não tem significado técnico — só serve pra humanos acharem coisa.
Arquivos podem ser livremente renomeados, movidos, ou fundidos sem afetar
a config resultante.

[Den](https://den.denful.dev) implementa esse padrão como framework
aspect-oriented sobre flake-parts. Quatro conceitos centrais, cada um com
um job:

| Conceito   | O que é                                                  | Onde vive       |
| ---------- | --------------------------------------------------------- | --------------- |
| **Entity** | Registro tipado — um host ou user                          | `den.hosts`     |
| **Aspect** | Unidade composável de config que atravessa Nix classes      | `den.aspects`   |
| **Policy** | Como entidades se relacionam e roteiam dados (built-in)     | `den.policies`  |
| **Battery**| Padrão reusável pronto (define-user, hostname, etc)         | `den.batteries` |

Um **aspect** é um attrset com módulos de diferentes Nix **classes**
(`nixos`, `homeManager`, etc — classes não são invenção do Den, é um
conceito usado em vários lugares do ecossistema Nix). Este repo usa duas
classes: `nixos` e `homeManager` (setado em `den.schema.user.classes` em
`modules/system/den.nix`).

`den.batteries.*` (aliases: `den.provides.*`, `den._`) são os padrões
prontos que o Den distribui. Usados neste repo:
- `define-user` — cria a conta OS (`users.users.<nome>`)
- `hostname` — seta `networking.hostName` a partir de `den.hosts.<host>.hostName`
- `primary-user` — grupos `wheel`/`networkmanager`
- `(user-shell "fish")` — habilita o shell em ambas as classes

`import-tree` descobre todo `.nix` sob `modules/` automaticamente — não
existe wiring manual de imports entre arquivos, exceto quando um arquivo
referencia outro aspect explicitamente via `den.aspects.<nome>` dentro de
`includes` (isso forma um DAG, não uma árvore de imports).

`flake.nix` usa `inputs.flake-parts.lib.mkFlake { inherit inputs; }
(inputs.import-tree ./modules)`. Não trocar isso por `evalModules` cru —
quebra `perSystem` e qualquer outra opção que dependa da infra do
flake-parts.

### Anti-pattern oficial a evitar: `specialArgs` pass-thru

O próprio README do padrão dendrítico documenta isso como o anti-pattern
canônico: **não** injetar valores (como `self`, um script, um pacote
custom) via `specialArgs`/`extraSpecialArgs` pra fazer um arquivo
"alcançar" outro. Em vez disso, qualquer módulo pode ler e escrever no
`config` de topo diretamente — é assim que valores como `inputs` e `self`
chegam em todo módulo sem wrapper nenhum. Ver `${inputs.self}/secrets/secrets.yaml`
em `modules/system/secrets/default.nix` como exemplo de uso correto de
`inputs.self` em vez de path relativo (`../../../secrets/...`), que
quebraria se o arquivo fosse movido — indo contra a "file path
independence" que é um benefício central do padrão.

### flake.nix é gerado — não editar à mão

`flake.nix` tem `flake-file.inputs` declarado de forma distribuída: cada
módulo que consome um input de flake não-core declara esse input ali
mesmo (ex: `modules/desktop/compositors/niri/default.nix` declara
`flake-file.inputs.niri`).

`modules/flake/inputs.nix` habilita o mecanismo: importa
`inputs.flake-file.flakeModules.default` e declara os inputs fundamentais do
flake (`nixpkgs`, `flake-file`, `flake-parts`, `import-tree` e Home Manager).
Integrações adicionais declaram seus próprios inputs junto do consumidor:
`den/flake-module.nix`, `tooling/formatter.nix` e `tooling/pre-commit.nix`.
Não setar
`flake-file.outputs` manualmente além do que já está lá — o preset
`"dendritic"` produz `outputs = inputs: inputs.flake-parts.lib.mkFlake
{ inherit inputs; } (inputs.import-tree ./modules);` sem intervenção.

Depois de adicionar/mudar um `flake-file.inputs`, rodar
`nix run .#write-flake` pra regenerar o `flake.nix` na raiz, depois
`git add -A` (import-tree só enxerga o que o git já rastreia). Nunca
editar o `flake.nix` diretamente — ele tem cabeçalho `DO-NOT-EDIT`.

## Convenções de pasta

- `flake/` — inputs fundamentais e formato dos outputs do flake:
  a importação do flake-file e o output dendrítico. Não contém políticas de
  host/user nem ferramentas de qualidade.
- `den/` — o input e módulo do framework em `flake-module.nix`; `schema/`
  contém defaults de entidades e as opções adicionais de host/user.
- `tooling/` — formatter, análise estática e hooks usados no desenvolvimento
  do repositório.
- `applications/` — software que o usuário **abre e interage diretamente**
  (browsers, editor, terminal, jogos, ferramentas de dev). Critério: se a
  pessoa consegue nomear "o programa" ao descrever o que o arquivo faz, é
  app.
- `features/` — capacidades de **sistema/hardware** que existem
  independente de qualquer programa estar rodando (`services.*`,
  `hardware.*`, `networking.*` sem app associado — bluetooth, wifi,
  auto-cpufreq). Critério: a capacidade continuaria fazendo sentido
  mesmo sem nenhum app do repo usá-la.
  - `applications/hardware/peripherals/` (logiops, solaar) fica em
    `applications/` e não em `features/` apesar de ser "driver de hardware",
    porque cada um só faz sentido combinado com um periférico específico que
    o usuário escolheu ter — não é uma capacidade genérica da máquina.
- `identities/` — bundles puros (`includes = [...]`) que combinam
  apps+features num papel de host/user. Não tem lógica própria além de
  composição condicional via `host.isX`/`user.isX`.
- `system/essential/` — **um único aspect** (`den.aspects.essential`)
  fatiado em vários arquivos por assunto (core, nix-settings, locale,
  audio, network, xserver, fonts, ssh...). Cada arquivo faz
  `den.aspects.essential.nixos = { ... }: { ... };` ou
  `.homeManager = ...` — o Nix funde as definições automaticamente. Não
  criar um novo aspect por arquivo aqui; é intencionalmente tudo
  `essential`, só picotado pra achar coisa rápido.
- `den.schema.host.includes` é a fonte única do baseline de todo host:
  `essential`, `security`, `kernel`, `kernel-tuning` e `flatpak`. Cada
  `hosts/<nome>/default.nix` soma apenas o que é específico daquele host
  (bootloader, `secrets`, desktop environment e `_hardware.nix` gerado por
  `nixos-generate-config`, nunca editado à mão).
- `den.schema.user.includes` é a fonte única do baseline de todo usuário:
  `define-user`, `primary-user` e `(user-shell "fish")`. Cada
  `users/<nome>.nix` soma apenas os apps e gostos pessoais daquele usuário.

## Includes globais e stacks mistas

`den.schema.host.includes` aplica diretamente `essential`, `security`,
`kernel`, `kernel-tuning` e `flatpak` a todo host. Flatpak permanece um aspect
separado em `system/flatpak`: ele pertence ao host porque habilita serviço,
atualizações e portais XDG, mas não faz parte do baseline `essential`. Os
aspects de aplicações apenas contribuem pacotes para
`services.flatpak.packages`. `den.schema.user.includes` aplica diretamente
as batteries de criação, privilégios e shell a todo usuário.

`gaming-stack` agrega a coleção completa de jogos, emuladores, launchers,
compatibilidade, desempenho, controles e mods. Ela mistura aspects das classes
`nixos` e `homeManager`. O usuário é seu dono: `flp` inclui a stack uma única
vez e `gaming-stack.provides.to-hosts.includes` entrega as fatias NixOS dos
mesmos componentes aos hosts relacionados.

## Padrão oficial: host↔user mutual providers

Confirmado na [doc oficial](https://den.denful.dev/guides/mutual/):
cross-entity routing (host contribuindo config pro user, e vice-versa) é
**built-in no pipeline** — não precisa de nenhuma battery pra isso.
`den.batteries.mutual-provider` é hoje só um *inert compatibility shim*
(não faz mais nada), mantido só pra repos antigos não quebrarem.

O padrão certo é `provides.<alvo>` num aspect de host ou user:
- `provides.to-users` (num aspect de **host**) — entrega a config pra
  todo user daquele host
- `provides.to-hosts` (num aspect de **user**) — entrega a config pra
  todo host onde esse user vive
- `provides.<nome-especifico>` — entrega só pra aquele host/user nomeado

Usado em `hosts/desktop/default.nix`:

```nix
den.aspects.desktop = {
  includes = [ ... ];              # config do próprio host (classe nixos)
  provides.to-users.includes = with den.aspects; [
    identities
    essential                       # entrega a fatia homeManager de essential pro flp
  ];
};
```

**Por que `essential` precisa estar em `provides.to-users` e não só em
`includes`:** `includes` no aspect do host só resolve a classe `nixos`
daquele aspect. `essential` mistura `nixos.stateVersion` e
`homeManager.stateVersion` no mesmo aspect — sem `provides.to-users`, a
fatia `homeManager` fica sem nenhum caminho de chegar no user, e
`home-manager.users.<user>.home.stateVersion` falha por não ter valor
definido.

### Regra prática: quem é "dono" de um aspect misto

Não existe regra do Den sobre em qual lado (host ou user) um aspect
*deve* ser `includes`d — isso é decisão de design do repo, caso a caso.
A convenção deste repo: o lado em que o aspect aparece no `includes` é
o dono declarado (ex: `kde`/`security` são incluídos em `desktop.includes`
→ o **host** é dono; `niri`/`solaar` são incluídos em `flp.includes` →
o **user** é dono). Quando esse aspect também define a *outra* classe
(`homeManager` num aspect dono-host, ou `nixos` num aspect dono-user),
essa classe minoritária **precisa** de `provides.to-users`/`to-hosts`
pra ter algum caminho de chegar no outro lado — sem isso ela fica órfã
e nunca é avaliada, silenciosamente (não dá erro até algo tentar ler
uma opção que dependia dela, como aconteceu com `sops` no `git`).

Isso é exatamente o padrão do exemplo canônico do
[README oficial do Den](https://github.com/denful/den):

```nix
# host contribui pra todos seus users
den.aspects.igloo.provides.to-users.homeManager.programs.helix.enable = true;

# user contribui pra todos os hosts onde vive
den.aspects.tux.provides.to-hosts.nixos.programs.nh.enable = true;
```

**Auditoria feita em 2026-07-31**: todo aspect com classes `nixos` +
`homeManager` no mesmo aspect foi verificado quanto a essa regra.
Corrigidos (adicionado `provides` faltante): `kde` (dono host, faltava
`provides.to-users.homeManager`), `security`/keyring (dono host,
faltava `provides.to-users.homeManager` só na fatia do
`security/keyring.nix`), `niri` (dono user, faltava
`provides.to-hosts.nixos`), `solaar` (dono user, faltava
`provides.to-hosts.nixos`), `git` (dono user, faltava
`provides.to-hosts.nixos` — caso original que motivou essa auditoria,
ver `applications/development/version-control/github-token.nix`).
`fish.nixos.programs.fish.enable`
identificado como provavelmente redundante com a battery
`(user-shell "fish")` já incluída em `den.schema.user.includes` — não corrigido
ainda, pendente de confirmação (ver `HANDOFF.md`).

**Não é bug do Den.** O erro `attribute 'sops' missing` que motivou
essa auditoria foi causado por não seguir essa regra (adicionar
`nixos` a um aspect dono-user sem `provides.to-hosts`), não por
qualquer defeito do framework. A "file path independence" citada nesse
documento vem do `import-tree` (que descobre e importa qualquer `.nix`
sob `modules/` automaticamente), não do Den — o Den é quem implementa
o roteamento `provides`/`includes` por cima disso.

## Antes de propor mudança estrutural

- Não inventar mecanismo interno do Den não documentado (`_module.args`
  custom, sobrescrever `config.den.aspects` globalmente, etc). Den
  distingue claramente "Den context" (`{ host, user }`, resolvido *antes*
  da avaliação de módulos, via dispatch paramétrico de função) de
  argumentos de módulo NixOS (`{ config, pkgs, lib, ... }`) — são
  mecanismos diferentes que coexistem na mesma função, não devem ser
  confundidos ou misturados manualmente.
- Se algo parecer que "devia ser automático sem incluir em lugar
  nenhum", checar primeiro a [referência de batteries](https://den.denful.dev/reference/batteries/)
  — a maioria das necessidades comuns (autologin, WSL, unfree, insecure,
  hostname) já tem uma battery pronta, opt-in ou auto-ativada.
- Cache binário: qualquer input de flake com Cachix próprio (ex:
  Noctalia) não deve usar `inputs.nixpkgs.follows`, ou o hash diverge do
  que está cacheado e ele recompila do zero.
- `nix.settings.substituters` **substitui** a lista padrão do NixOS, não
  soma. Sempre incluir `https://cache.nixos.org/` explicitamente junto de
  qualquer substituter extra.

## Segredos (chaves SSH etc)

`system/secrets/` usa [sops-nix](https://github.com/Mic92/sops-nix).
Chave de cifragem é derivada da chave de host SSH
(`/etc/ssh/ssh_host_ed25519_key`) — sem chave mestra separada. Cada host
tem sua própria chave SSH pessoal cifrada em `secrets/secrets.yaml`,
listada em `.sops.yaml` por host. Passo a passo completo pra gerar/
adicionar host novo: `secrets/README.md`.

`den.aspects.ssh-identity-for` é um aspect **parametrizado** (função, não
attrset direto) — `(ssh-identity-for { user = "flp"; })` dentro de
`includes`. Isso é o padrão de [Parametric Aspects](https://den.denful.dev/explanation/parametric/)
do Den; mesma técnica usada por `user-shell "fish"` e `unfree [...]` nas
batteries oficiais. A chave usada dentro do secret
(`ssh.${config.networking.hostName}.*`) usa `config.networking.hostName`
em vez de repetir o nome do host como parâmetro — evita duplicar o dado
que `den.batteries.hostname` já define.

## Fontes: todos os frameworks e inputs externos usados

Lista de todo `flake-file.inputs.*` declarado no repo hoje (ver
`modules/flake-file/inputs.nix` pros inputs core, e o próprio arquivo
de cada aspect pros inputs específicos de feature), com link de doc
oficial. Manter esta tabela em dia sempre que um `flake-file.inputs`
novo for adicionado ou removido.

| Input | Repo | Doc / Fonte |
| --- | --- | --- |
| `den` | `denful/den` | https://den.denful.dev |
| `flake-file` | `denful/flake-file` | https://github.com/denful/flake-file |
| `import-tree` | `denful/import-tree` | https://github.com/denful/import-tree |
| `nixpkgs` | `nixos/nixpkgs` (unstable) | https://github.com/NixOS/nixpkgs |
| `flake-parts` | `hercules-ci/flake-parts` | https://flake.parts |
| `home-manager` | `nix-community/home-manager` | https://nix-community.github.io/home-manager |
| `treefmt-nix` | `numtide/treefmt-nix` | https://github.com/numtide/treefmt-nix |
| `git-hooks` | `cachix/git-hooks.nix` | https://github.com/cachix/git-hooks.nix |
| `nixcord` | `4evy/nixcord` | https://github.com/4evy/nixcord |
| `go-live-bypass` | `bezumiya/GoLiveBypass` | https://github.com/bezumiya/GoLiveBypass |
| `niri` | `sodiboo/niri-flake` | https://github.com/sodiboo/niri-flake (doc completa em `docs.md` do repo) |
| `noctalia` | `noctalia-dev/noctalia` | https://github.com/noctalia-dev — **conferir** se a URL declarada bate com o repo real (`noctalia-shell` aparece como nome em outras referências da comunidade) |
| `nix-flatpak` | `gmodena/nix-flatpak` | https://github.com/gmodena/nix-flatpak |
| `zen-browser` | `0xc000022070/zen-browser-flake` | https://github.com/0xc000022070/zen-browser-flake |
| `sops-nix` | `Mic92/sops-nix` | https://github.com/Mic92/sops-nix |
| `chaotic` (kernel cachy) | `chaotic-cx/nyx` | https://github.com/chaotic-cx/nyx — **atenção**: o repo original foi arquivado em 2025-12-08; forks ativos da comunidade (ex: `ninelore/chaotic-nyx`) continuam recebendo update. Se o input parar de atualizar/quebrar, trocar a URL pra um fork mantido é o caminho, não esperar o original voltar. |

Padrão dendrítico geral (não é input, é a metodologia): https://github.com/mightyiam/dendritic

## Ferramentas do dia a dia (fish functions)

Definidas em `modules/applications/shell/fish/functions.nix`:
- `write-flake` — regenera `flake.nix` (`nix run .#write-flake`) e já
  stage o resultado (`git add -A` + mostra o diff cacheado de
  `flake.nix`), pra revisar antes de commitar.
