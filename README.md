# NixOS Config

## TL;DR

Meu setup pessoal em Nix, seguindo o [padrão dendrítico](https://github.com/mightyiam/dendritic): cada arquivo em `modules/` é um módulo do flake que descreve **uma funcionalidade**

```sh
./bootstrap.sh [nome_do_host]                           # primeira instalação de um host
nh os switch                                            # aplica sistema + home do host atual
nh os switch -H myhost --target-host root@myhost.local  # aplica em outra máquina, via SSH
nh home switch                                          # home standalone (Nix fora do NixOS)
nix fmt                                                 # formata o repositório
```

## Estrutura

- [`modules/`](modules/) - Toda a configuração
- [`assets/`](assets/) - Arquivos não Nix, como imagens, usados pelos módulos
- [`bootstrap.sh`](bootstrap.sh) - Primeira instalação de um host
- [`AGENTS.md`](AGENTS.md) - Regras do repositório
- [`HANDOFF.md`](HANDOFF.md) - Estado atual e próximos passos

## Ferramentas

### Essencial

- [Nix](https://nixos.org) - Linguagem e gerenciador de pacotes declarativo e reproduzível
- [Flakes](https://wiki.nixos.org/wiki/Flakes) - Gerencia as entradas (inputs) do projeto com as dependências travadas no [`flake.lock`](flake.lock), tornando o resultado determinístico
- [Home Manager](https://github.com/nix-community/home-manager) - Configura o ambiente do usuário (dotfiles, programas, serviços) de forma declarativa

No NixOS e no Home Manager, cada programa é ligado e configurado por opções:

```nix
programs.myprogram = {
  enable = true;
  settings.foo = "bar";
};
```

### Padrão dendrítico

#### 1. [flake-parts](https://flake.parts/)

Transforma o flake num sistema de módulos, o mesmo do NixOS: em vez de um `flake.nix` gigante, vários arquivos contribuem cada um com um pedaço das saídas.

**Sem flake-parts**, tudo fica num arquivo só, e o que é por arquitetura se repete para cada uma:

```nix
# flake.nix
{
  outputs = { nixpkgs, ... }: {
    packages.x86_64-linux.foo = nixpkgs.legacyPackages.x86_64-linux.hello;
    packages.aarch64-linux.foo = nixpkgs.legacyPackages.aarch64-linux.hello;

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt;

    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem { ... };
  };
}
```

**Com flake-parts**, cada arquivo é um módulo, e o `perSystem` é escrito uma vez e vale para todas as arquiteturas:

```nix
# flake.nix
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" ];
    imports = [ ./foo.nix ./formatter.nix ];
  };
}
```

```nix
# foo.nix
{
  perSystem = { pkgs, ... }: {
    packages.foo = pkgs.hello;
  };
}
```

```nix
# formatter.nix
{
  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixfmt;
  };
}
```

Como é um sistema de módulos, um arquivo também pode criar uma opção que outros preenchem. Aqui o flake-parts cuida de tudo que não é máquina nem usuário: `nix fmt`, hooks, dev shell e a checagem de inputs repetidos ([`modules/tooling/`](modules/tooling/)). Máquinas e usuários ficam com o Den, que também é um módulo de flake-parts.

#### 2. [import-tree](https://github.com/denful/import-tree)

Importa todos os arquivos `.nix` dentro de `modules/`, então o `imports = [ ... ]` acima não precisa ser escrito à mão. Arquivos e pastas com `_` no início ficam de fora.

#### 3. [flake-file](https://github.com/denful/flake-file)

Gera o `flake.nix` a partir dos módulos. Cada módulo declara o input que usa:

```nix
{
  flake-file.inputs.myprogram = {
    url = "github:foo/myprogram";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Depois de mudar inputs, rode `nix run .#write-flake`. O [`flake.nix`](flake.nix) nunca deve ser editado à mão.

#### 4. [Den](https://den.denful.dev)

Organiza a config em **aspects**. Um aspect junta tudo de uma funcionalidade (NixOS e Home Manager) num lugar só, e hosts e usuários só escolhem quais aspects incluir.

**Sem Den** (apenas flake-parts), cada parte é um módulo solto, e o host monta o sistema e a home à mão:

```nix
# myprogram.nix
{
  flake.modules = {
    nixos.myprogram = {
      programs.myprogram.enable = true;
    };
    homeManager.myprogram = {
      programs.myprogram.settings.foo = "bar";
    };
  };
}
```

```nix
# myhost.nix
{ inputs, config, ... }: {
  flake.nixosConfigurations.myhost = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos.myprogram
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.users.foo.imports = [ config.flake.modules.homeManager.myprogram ];
      }
    ];
  };
}
```

**Com Den**, o host só declara quem ele é e o que inclui, e o Den monta o sistema e a home:

```nix
# myprogram.nix
{
  den.aspects.myprogram = {
    nixos = {
      programs.myprogram.enable = true;
    };
    homeManager = {
      programs.myprogram.settings.foo = "bar";
    };
  };
}
```

```nix
# myhost.nix
{ den, ... }: {
  den = {
    hosts.x86_64-linux.myhost.users.foo = { };
    aspects.myhost.includes = [ den.aspects.myprogram ];
  };
}
```

O Den também tem outros recursos, todos usados neste repositório:

- **Entidades** - Hosts (`den.hosts.<arch>.<host>`), os usuários de cada host (`users.<nome>`) e homes standalone para Nix fora do NixOS (`den.homes`). O mesmo aspect de usuário serve nos dois casos
- **Schemas** - Opções próprias de cada host. Aqui cada host escolhe kernel, navegador e GPUs, e um aspect lê a escolha e inclui o aspect certo (`*-schema.nix`)
- **Aspects com parâmetros** - Um aspect pode ser uma função de `{ host }`, `{ user }` ou `{ host, user }` e montar a config a partir desses dados
- **Padrões** - O que todo mundo recebe fica em [`modules/defaults.nix`](modules/defaults.nix): `den.default.includes` para hosts, usuários e homes, e `den.schema.{host,user,home}.includes` para cada tipo
- **Rotas entre host e usuário** - O `nixos` de um aspect do usuário chega sozinho a todo host onde ele está. Já o `homeManager` de um aspect do host precisa de `provides.to-users`, ou do `den.batteries.host-aspects`, ligado na base, que leva o `homeManager` de tudo que o host inclui
- **Batteries** - Aspects prontos do Den: `hostname` (nome da máquina), `primary-user` (grupos de admin), `user-shell` (shell padrão), `define-user` (cria o usuário no sistema e na home) e `host-aspects`

Um schema com um aspect que o lê, e o host escolhendo:

```nix
# browser-schema.nix
{
  den.schema.host.options.browser = lib.mkOption {
    type = lib.types.enum [ "firefox" "google-chrome" ];
  };

  den.aspects.default-browser = { host, ... }: {
    includes = [ den.aspects.${host.browser} ];
  };
}
```

```nix
# myhost.nix
{
  den.hosts.x86_64-linux.myhost.browser = "firefox";
}
```

Um aspect que manda config do host para os usuários:

```nix
# myprogram.nix
{
  den.aspects.myprogram = {
    nixos = {
      services.myprogram.enable = true;
    };
    provides.to-users = {
      homeManager = {
        programs.myprogram.enable = true;
      };
    };
  };
}
```

### Ferramentas de desenvolvimento

- [treefmt-nix](https://github.com/numtide/treefmt-nix) - `nix fmt` formata tudo
- [git-hooks.nix](https://github.com/cachix/git-hooks.nix) - Hooks de pre-commit (formatação, estilo Nix, mensagem de commit, inputs repetidos)
- [nh (Nix Helper)](https://github.com/nix-community/nh) - Aplica a config do NixOS e do Home Manager mostrando o que mudou, e limpa gerações antigas (comandos no [TL;DR](#tldr))

### Visual

- [Stylix](https://github.com/nix-community/stylix) - Aplica um tema (escolhido por usuário), fontes e cursor no sistema e nos apps

## Novo host

1. Copie `modules/hosts/template/` para `modules/hosts/<novo-host>/` e ajuste `hostName`, `kernel`, `browser`, `gpus` e os aspects
2. Na máquina, gere o `_hardware.nix` com `nixos-generate-config --show-hardware-config` ou copie o existente em `/etc/nixos/hardware-configuration.nix`
3. Renomeie `_default.nix` para `default.nix`, rode `git add` e `./bootstrap.sh <novo-host>`

Para Nix fora do NixOS, o modelo é [`modules/hosts/template/_home.nix`](modules/hosts/template/_home.nix) (`den.homes`), aplicado com `nh home switch`.
