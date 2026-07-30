# AGENTS.md

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
mesmo (ex: `modules/desktop/wm/niri/default.nix` declara `flake-file.inputs.niri`).

`modules/flake-parts/core.nix` habilita o mecanismo: importa
`inputs.flake-file.flakeModules.default` e declara os inputs core
(nixpkgs, flake-parts, import-tree, home-manager, treefmt-nix,
git-hooks). Não setar `flake-file.outputs` manualmente além do que já
está lá — o preset `"dendritic"` já é o default do próprio pacote
flake-file e produz `outputs = inputs: inputs.flake-parts.lib.mkFlake
{ inherit inputs; } (inputs.import-tree ./modules);` sem intervenção.

Depois de adicionar/mudar um `flake-file.inputs`, rodar
`nix run .#write-flake` pra regenerar o `flake.nix` na raiz, depois
`git add -A` (import-tree só enxerga o que o git já rastreia). Nunca
editar o `flake.nix` diretamente — ele tem cabeçalho `DO-NOT-EDIT`.

## Convenções de pasta

- `apps/` — software que o usuário **abre e interage diretamente**
  (browsers, editor, terminal, jogos, ferramentas de dev). Critério: se a
  pessoa consegue nomear "o programa" ao descrever o que o arquivo faz, é
  app.
- `features/` — capacidades de **sistema/hardware** que existem
  independente de qualquer programa estar rodando (`services.*`,
  `hardware.*`, `networking.*` sem app associado — bluetooth, wifi,
  auto-cpufreq). Critério: a capacidade continuaria fazendo sentido
  mesmo sem nenhum app do repo usá-la.
  - `apps/peripherals/` (logiops, solaar) fica em `apps/` e não em
    `features/` apesar de ser "driver de hardware", porque cada um só
    faz sentido combinado com um periférico específico que o usuário
    escolheu ter — não é uma capacidade genérica da máquina.
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
- `hosts/standard-host.nix` — esqueleto reusável (`essential`,
  `security`, `kernel`) pra todo host físico. `hosts/<nome>/default.nix`
  inclui esse aspect e soma o que for específico daquele host
  (bootloader, `secrets`, desktop environment, `_hardware.nix` gerado
  por `nixos-generate-config`, nunca editado à mão).
- `users/standard-user.nix` — mesma ideia, lado home-manager
  (`define-user`, `primary-user`, shell). Cada `users/<nome>.nix` inclui
  esse aspect e soma só os apps/gostos pessoais daquele usuário.

## Padrão de identity flags

`host.isLaptop` e `user.isGaming` são options declaradas via
`den.schema.host.imports` / `den.schema.user.imports` (ver
`modules/system/schema/host-schema.nix` e `user-schema.nix`) — não são
freeform. Note a assimetria: `isLaptop` é propriedade do **host**
(a máquina), `isGaming` é propriedade do **user** (quem usa a máquina).
Setados em `modules/hosts/<nome>/default.nix`, na forma:

```nix
den.hosts.x86_64-linux.<host> = {
  isLaptop = false;
  users.<user> = { isGaming = true; };
};
```

A lógica de "o que cada flag ativa" mora em `modules/identities/default.nix`
(`den.aspects.identities`), usando `lib.optionals (host.isLaptop or false)`
e `lib.optionals (user.isGaming or false)`.

`identities` é incluído tanto no aspect do **host** quanto no aspect do
**user** correspondente. Isso é intencional, não duplicação por engano:
aspects de identity como `gaming` misturam classes `nixos` (steam,
gamescope, graphics...) e `homeManager` (mangohud...), e cada classe só
é resolvida no contexto certo (host para `nixos`, user para
`homeManager`). Incluir `identities` nos dois lados garante que ambas as
classes sejam alcançadas.

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

Usado em `hosts/atlas/default.nix`:

```nix
den.aspects.atlas = {
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

## Ferramentas do dia a dia (fish functions)

Definidas em `modules/apps/fish/functions.nix`:
- `rebuild` — `git add -A` + `nh os switch .`
- `rebuild-test` — idem, sem persistir no boot menu (`nh os test`)
- `rebuild-update` — atualiza `flake.lock` + rebuild
- `flake-regenerate` — só roda `write-flake`, sem rebuild (revisar diff)
- `rebuild-with-new-inputs` — `write-flake` + `git add -A` + rebuild
  (usar sempre que um `flake-file.inputs` for adicionado/mudado)
