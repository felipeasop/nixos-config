# AGENTS.md

Contexto pra IA (ou humano) mexer nesse repo sem quebrar convenções.

## Framework

Den (https://den.denful.dev) por cima de flake-parts, com import-tree
descobrindo todo `.nix` sob `modules/` automaticamente — não existe wiring
manual de imports entre arquivos, exceto quando um arquivo referencia
outro aspect explicitamente via `den.aspects.<nome>` dentro de `includes`.

`flake.nix` usa `inputs.flake-parts.lib.mkFlake { inherit inputs; }
(inputs.import-tree ./modules)`. Não trocar isso por `evalModules` cru —
quebra `perSystem` e qualquer outra opção que dependa da infra do
flake-parts.

### flake.nix é gerado — não editar à mão

`flake.nix` tem `flake-file.inputs` declarado de forma distribuída: cada
módulo que consome um input de flake não-core declara esse input ali
mesmo (ex: `modules/desktop/wm/niri/default.nix` declara `flake-file.inputs.niri`).

Dois módulos raiz habilitam o mecanismo (espelhando `drupol/infra`,
outro repo Den+flake-file — github.com/drupol/infra):
- `modules/flake-file.nix` — só importa `inputs.flake-file.flakeModules.default`
- `modules/flake-parts/pkgs.nix` — inputs core (nixpkgs, flake-parts,
  import-tree, home-manager, treefmt-nix, git-hooks,
  pkgs-by-name-for-flake-parts) + `pkgsDirectory`

Não setar `flake-file.outputs` manualmente — o `outputs = inputs: ...`
continua escrito no `flake.nix` gerado por padrão, sem precisar mexer
nessa opção.

Depois de adicionar/mudar um `flake-file.inputs`, rodar
`nix run .#write-flake` pra regenerar o `flake.nix` na raiz. Nunca editar
o `flake.nix` diretamente — ele tem cabeçalho `DO-NOT-EDIT`.

### pkgs/by-name

Pacotes locais fora do nixpkgs vão em `pkgs/by-name/<nome>/default.nix`
e viram `packages.<nome>` automaticamente via
`pkgs-by-name-for-flake-parts`. Ver `pkgs/README.md`.

## Convenções de pasta

- `apps/` — software instalável, sempre igual independente de contexto
  (discord, spotify, git, steam...). Se o arquivo só define
  `home.packages`/`programs.X.enable` sem depender de `host`/`user`, é app.
- `features/` — capacidades de sistema, cada uma independente das outras,
  sem saber da existência de "laptop"/"gaming"/etc. Reutilizáveis em
  qualquer combinação futura.
- `identities/` — bundles puros (`includes = [...]`) que combinam
  apps+features num papel de host. Não tem lógica própria além de
  composição condicional via `host.isX`.
- `system/essential/` — **um único aspect** (`den.aspects.essential`)
  fatiado em vários arquivos por assunto (core, nix-settings, locale,
  audio, network, xserver, fonts, ssh, firewall). Cada arquivo faz
  `den.aspects.essential.nixos = { ... }: { ... };` — o Nix funde as
  definições automaticamente. Não criar um novo aspect por arquivo aqui;
  é intencionalmente tudo `essential`, só picotado pra achar coisa rápido.
- `hosts/<nome>/default.nix` — só monta a lista de `includes` pro host;
  hardware real fica em `_hardware.nix` (gerado por
  `nixos-generate-config`, não editar à mão).
- `users/<nome>.nix` — mesma ideia, mas pro lado home-manager. Infra
  comum de usuário (define-user, primary-user, shell) fica em
  `users/standard-user.nix` (`den.aspects.standard-user`); cada
  `users/<nome>.nix` inclui esse aspect e soma só os apps/gostos
  pessoais daquele usuário.

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
**user** correspondente (ver `hosts/atlas/default.nix` e `users/flp.nix`).
Isso é intencional, não duplicação por engano: aspects de identity como
`gaming` misturam classes `nixos` (steam, gamescope, graphics...) e
`homeManager` (mangohud...), e cada classe só é resolvida no contexto certo
(host para `nixos`, user para `homeManager`). Incluir `identities` nos dois
lados garante que ambas as classes sejam alcançadas.

## Antes de propor mudança estrutural

- Não inventar mecanismo interno do Den não documentado (`_module.args`
  custom, sobrescrever `config.den.aspects` globalmente, etc). Se algo
  parecer que "devia ser automático sem incluir em lugar nenhum", checar
  primeiro se o padrão oficial do Den já resolve com uma linha a mais no
  `includes` — geralmente resolve.
- Cache binário: qualquer input de flake com Cachix próprio (ex:
  Noctalia) não deve usar `inputs.nixpkgs.follows`, ou o hash diverge do
  que está cacheado e ele recompila do zero.
- `nix.settings.substituters` **substitui** a lista padrão do NixOS, não
  soma. Sempre incluir `https://cache.nixos.org/` explicitamente junto de
  qualquer substituter extra.
