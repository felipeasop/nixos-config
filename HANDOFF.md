# HANDOFF

Last updated: 2026-09-10 22:58 UTC

## Current State

O Helium foi avaliado, mas removido a pedido do usuário: ele não está
disponível no `nixpkgs` fixado e o flake externo acrescentaria um input e uma
dependência de empacotamento que não fazem parte do escopo atual. O input foi
retirado de `flake.nix` e `flake.lock`, e o perfil `flp` não o inclui mais.
Nenhum segredo foi adicionado.

O GameMode foi desacoplado do Steam e agora é um aspect próprio da
`gaming-stack`, usando diretamente o módulo NixOS
`programs.gamemode.enable`. Azahar continua usando sua integração nativa, que
já funcionava. O pacote do Eden ganhou somente um wrapper de empacotamento que
expõe o output `lib` do GameMode em `LD_LIBRARY_PATH`; isso corrige o erro
registrado por ele ao carregar `libgamemode.so`, sem gerenciar seus arquivos
INI. A tentativa de centralizar opções gráficas num gerenciador próprio de INI
foi rejeitada e removida: Azahar e Eden não têm módulos Home Manager nativos
para essas preferências, e controlar o INI inteiro o tornaria somente-leitura.
Uma cópia temporária limpa passou em `nix flake check --no-build
--no-write-lock-file`, e a ativação Home Manager completa, incluindo o wrapper
do Eden, foi construída com sucesso. Nenhum segredo foi adicionado.

O flake agora expõe `devShells.default` para corresponder ao `use flake` do
`.envrc`. O output reutiliza diretamente `config.pre-commit.devShell`, já
produzido por `git-hooks.nix`; assim, os hooks, seus pacotes e o wrapper do
treefmt continuam definidos uma única vez. A avaliação direcionada confirmou o
output como `nix-shell`. O texto `impure` ainda pode aparecer no Starship porque
`nix develop` normalmente herda o ambiente do terminal; ele não indica
`nix build --impure` nem falta de reprodutibilidade dos inputs. Nenhum segredo
foi adicionado.

O prompt `pure` do Fish foi substituído pelo Starship, instalado e inicializado
declarativamente pelo Home Manager. O aspecto independente `starship` é
incluído pelo perfil `flp` e mantém o greeting com Tux. O prompt compacto usa
a paleta Everforest e mostra diretório, estado Git, ambiente Nix/direnv,
duração de comandos, jobs e códigos de saída; a fonte JetBrainsMono Nerd Font
já configurada fornece os símbolos. Validação: `nix flake check --no-build
--no-write-lock-file` passou para `desktop` e `template`, e a configuração
Starship resultante foi avaliada em JSON. Nenhum segredo foi adicionado.

O timeout de comandos do Starship é de 2 s para acomodar a ativação inicial do
`direnv` em ambientes Nix. A migração do nixpkgs atual também substituiu a
opção removida `services.journald.extraConfig` por
`services.journald.settings.Journal.SystemMaxUse`; a avaliação integral voltou
a passar. O `config.kdl` do Niri, incluindo os binds do helper de workspace,
passa em `niri validate`. A sessão Niri iniciada antes de uma reinicialização
do SDDM ficou ativa no systemd mas inativa no logind; isso bloqueia uma nova
sessão até encerrar a unidade residual, não é um erro da configuração KDL.
O Ghostty residual também pertence àquela sessão Niri: como o desktop entry
usa instância única, novos lançamentos são encaminhados ao processo antigo e
não aparecem na sessão Plasma. Pure/Starship só são carregados depois que o
terminal inicia e não podem causar a falha gráfica.
O Zed seleciona declarativamente `Noctalia Dark`; o template comunitário do
Noctalia escreve apenas `~/.config/zed/themes/noctalia.json` e atualiza as
cores dessa definição a partir da paleta Everforest, sem precisar modificar o
`settings.json` gerenciado pelo Home Manager. A avaliação integral passou
depois do ajuste. O `init.lua` do Neovim continua referenciado localmente por
`./init.lua`, sem acoplamento à estrutura do repositório.

Auditoria de avaliação concluída. Foram migrados os aliases obsoletos do
LibreOffice (`libreoffice-qt-stable`) e do Neovim (`initLua`), o Solaar passou
para o módulo NixOS oficial `programs.solaar.userService`, e o Flatpak fornece
`xdg.portal.config.common.default = lib.mkDefault "*"` para hosts mínimos. O
pacote duplicado do Solaar no Home Manager e a assertion associada foram
removidos, pois o módulo NixOS oficial já instala o mesmo pacote globalmente. O
helper `write-flake` do Fish não depende mais da variável removida
`NIXOS_CONFIG_DIR`: o próprio módulo deriva o checkout de
`home.homeDirectory`.

Validação concluída com `nix flake check --no-write-lock-file`, build integral
dos hosts `desktop` e `template`, e `nh os test` no desktop. A ativação
temporária terminou com sucesso; não há unidades systemd falhas, o Home Manager
terminou com status zero e o serviço oficial do Solaar está habilitado e ativo.
Os únicos avisos do CLI que permanecem são informativos: árvore Git suja até os
commits e `unknown flake output 'denful'` apenas no `nix flake check`, pois a
versão oficial pinada do Den declara esse output para namespaces. Não há
evaluation warnings em `nh os build/test`.

A barra superior do Noctalia na sessão Niri foi reorganizada por função:
launcher à esquerda, `taskbar` ao centro e estado/ações imediatas à
direita. O widget nativo agrupa ícones por workspace, mantém o rótulo da área,
colapsa múltiplas janelas do mesmo app e marca a janela ativa; trabalha apenas
com o monitor da própria barra. Ele é referenciado diretamente, sem alias
customizado nem `type` redundante. Wallpaper, clipboard, bluetooth, brilho e
menu de sessão saíram da faixa permanente e continuam acessíveis pelos painéis
e atalhos. A sintaxe Nix e `git diff --check` passaram para os módulos da
barra. Nenhum segredo foi adicionado a arquivos rastreados.

O aspect opcional `mango` instala declarativamente a árvore completa
`~/.config/mango/` pelo Home Manager. `config.conf` só importa os fragmentos
`environment`, `input`, `layout`, `animations`, `rules`, `outputs` e `binds`,
mantendo a transcrição do Niri organizada fora do Nix. O módulo `config.nix`
cuida apenas do deployment; `default.nix` fica com descrição e o enable NixOS
roteado por `provides.to-hosts`. Os casos sem suporte direto ficaram comentados
como `SEM EQUIVALENTE` ou `PLACEHOLDER`, incluindo screenshots, overlay de
atalhos, workspaces dinâmicos e inserção de janela em workspace novo. O aspect
ainda não foi incluído no `desktop-stack`, portanto não troca a sessão atual.
`nix-instantiate --parse` e `git diff --check` passaram para os módulos. O
`nixfmt` e o binário `mango` não estão no PATH; o Git não permite criar
`.git/index.lock`, por isso os novos arquivos não puderam ser adicionados ao
índice neste ambiente. Noctalia continua condicionado a
`XDG_CURRENT_DESKTOP=niri`, então seus binds no Mango são placeholders até
estender essa integração. Nenhum segredo foi adicionado a arquivos rastreados.

O Niri ganhou o helper declarativo `niri-move-window-to-new-workspace`, que
move apenas a janela focada para um workspace novo imediatamente acima ou
abaixo do atual. Quando há várias janelas, o helper extrai a focada para o
workspace vazio final do monitor e reposiciona esse workspace; quando ela é a
única de um workspace dinâmico, move diretamente o próprio workspace para
evitar que a remoção automática do vazio anule visualmente a operação.
Workspaces nomeados seguem pelo fluxo de extração, pois persistem vazios. Os
binds cobrem J/K, setas e roda com `Mod+Ctrl+Alt`, e execuções concorrentes são
serializadas. Uma cópia temporária do índice passou em `nix flake check
--no-build --no-write-lock-file`.

Os três arquivos propostos para o aspect Bash continuam adicionados no índice,
mas apagados da árvore de trabalho; a configuração atualmente avaliada não os
inclui nem referencia. Essa inconsistência do índice não quebra o flake, mas
faz o walker do formatter avisar sobre arquivos ausentes até que se decida
restaurá-los ou remover as adições do índice.

O aspect `discord` usa agora o módulo Home Manager do Nixcord para instalar
somente Vesktop com um Vencord construído declarativamente. O cliente Discord
oficial está desabilitado. O GoLiveBypass entra como `userPlugin` a partir de
um input `flake = false` pinado e já fica habilitado com roteamento apenas do
gateway, saídas brasileiras excluídas e regiões automáticas. `WebScreenShare`
está ativo em 1080p/60 fps, junto de `WebScreenShareFixes`. As configurações
do cliente agora pertencem corretamente a `programs.nixcord.vesktop.settings`:
tray, aceleração, tamanho livre da janela, spellcheck PT-BR/EN-US e seleção
granular de áudio via PipeWire. O conjunto de plugins cobre correções do
cliente web, streaming, mídia, navegação, privacidade e estabilidade sem
automatizar interações sociais.

Validação: o Vencord 1.15.3 com GoLiveBypass e o Vesktop 1.6.7 foram construídos
com sucesso. O JSON declarativo gerado foi inspecionado e contém os plugins
e suas opções esperadas; os bundles finais contêm tanto o renderer quanto a
parte nativa do GoLiveBypass e os dois hosts de gateway. `nix flake check
--no-build --no-write-lock-file` passou após a ampliação da configuração. O
executável não pôde ser aberto dentro do sandbox gráfico do Codex; o teste real
de login, chamada e transmissão depende da sessão do usuário após o switch.

O aspect intermediário `standard-host` foi removido. O baseline agora aparece
diretamente em `den.schema.host.includes`: `essential`, `security`, `kernel`,
`kernel-tuning` e `flatpak`. Flatpak foi movido de `applications/system` para
`system/flatpak` e continua separado de `essential`, preservando controle para
condicioná-lo ou removê-lo futuramente. Ele habilita portais XDG e um fallback
genérico de backend, portanto hosts sem KDE também avaliam corretamente.

O baseline de usuário também foi achatado em
`den.schema.user.includes`: `define-user`, `primary-user` e
`(user-shell "fish")`. O aspect intermediário `standard-user` foi removido;
cada arquivo em `users/` agora contém apenas escolhas próprias do usuário.

`modules/flake-parts` foi desmembrado por responsabilidade. O bootstrap fica
em `modules/flake/inputs.nix` e reúne os inputs fundamentais do flake; não
há input estável adicional, apenas o nixpkgs unstable principal. Integração,
defaults e schemas do Den ficam em `modules/den/`: `flake-module.nix` integra
o framework e `schema/` reúne `entity-defaults`, `host-options` e
`user-options`; formatter e pre-commit ficam em `modules/tooling/`. Os inputs
`den`, `treefmt-nix` e `git-hooks` são
declarados junto de seus consumidores, e os dois inputs de tooling seguem o
`nixpkgs` principal.

O agregador de jogos foi renomeado para `gaming-stack` e reúne Steam, Sober,
Prism Launcher, Azahar, Eden, ProtonUp-Qt, Gamescope, controles, MangoHud e
r2modman. Ele é dono-user e incluído apenas em `flp`; suas fatias NixOS são
entregues aos hosts relacionados por `provides.to-hosts.includes`.

Validação: `flake.nix` foi regenerado, `flake.lock` atualizado e
`nix flake check` passou para `desktop` e `template`, incluindo os checks de
formatação e sincronização do arquivo gerado. `git-hooks` e `treefmt-nix` agora
seguem o `nixpkgs` raiz. O ref `latest` declarado pelo `nix-flatpak` continua
apontando para uma revisão de janeiro de 2026, anterior à revisão de julho
usada antes.

Os commits foram separados por responsabilidade seguindo Conventional Commits
em português. O hook local de Statix ainda aponta para uma configuração gerada
anterior; a configuração versionada foi corrigida para receber somente arquivos
staged e o Statix foi validado manualmente, excluindo `_hardware.nix` gerado.

## Top 3 Next Actions

- Adicionar `modules/applications/gaming/gamemode.nix` ao Git e aplicar a
  configuração para testar GameMode no Azahar e no Eden; o índice somente-leitura
  impediu o staging nesta sessão.
- Resolver a inconsistência dos arquivos de Bash apagados na árvore de trabalho
  mas ainda adicionados ao índice.
- Adicionar ao índice os novos módulos do Mango antes de validá-lo, pois flakes
  ignoram arquivos não rastreados; depois testar `mango -c` na sessão adequada.

## Blockers

Nenhum blocker de avaliação ou build. A árvore está em `detached HEAD`, o
índice Git está somente-leitura e possui mudanças parcialmente staged; além
disso, a configuração ainda não foi aplicada ao sistema real. Nenhum segredo
foi adicionado a arquivos rastreados.

---

## Current State

Investigação do Den concluída contra o commit pinado
`e8e8de1e32646456cfc613f152175a7a548508ec` e o `narHash` efetivo do
flake. O mutual routing já integra o pipeline nessa revisão; a battery
`mutual-provider` é apenas um shim inerte, portanto não foi adicionada.

`standard-host` e `standard-user` agora são defaults por tipo de entidade via
`den.schema.host.includes` e `den.schema.user.includes`. As inclusões repetidas
foram removidas dos hosts e do user `flp`. `provides.to-users = [ essential ]`
foi mantido: ele continua necessário para entregar a fatia `homeManager` do
aspect ao user e não gerou conflito de definições.

O host `nitro` continua desabilitado e recebeu comentário WIP porque o diretório
não contém `_hardware.nix`; habilitá-lo agora seria inseguro. Embora o RStudio
pinado não esteja disponível no cache `rstats-on-nix`, o usuário confirmou que
o substituter e sua chave devem permanecer configurados globalmente.

Validação: `nh os build . --hostname desktop --dry -- --no-write-lock-file`
passou com 15 derivações. `nix flake check --no-write-lock-file` avaliou os
outputs, mas o check de formatação falhou em mudanças não relacionadas de
`tmux.nix` e `applications/gaming/default.nix`.

## Top 3 Next Actions

- Decidir se `programs.nh.flake` deve apontar para `/home/flp/nixos-config`
  (checkout local) mantendo o auto-upgrade no GitHub.
- Confirmar que `den.schema.host.kernel` deve continuar obrigatório, sem
  `default`.
- Aprovar o plano de commits e separar as mudanças com `jj` quando o backend
  Git voltar a permitir snapshots.

## Blockers

As decisões sobre a origem do flake do `nh` e sobre `kernel` exigem confirmação
do usuário. Neste ambiente, `jj` não consegue gravar objetos em `.git/objects`;
por isso nenhum commit foi criado. Nenhum segredo foi adicionado a arquivos
rastreados.

---

## Current State

O aspect `direnv` não instala toolchains de C/C++, Java, Go, Rust ou Python
no perfil do usuário. As linguagens ficam declaradas nos `flake.nix` dos
projetos que as utilizam.

`tmux` foi isolado no módulo `modules/applications/development/tools/tmux.nix`
e incluído pelo aspect `dev`. A alteração foi validada com `git diff --check`,
mas `nix flake check`/`nh os switch` não puderam acessar o daemon Nix neste
ambiente; a solicitação de permissão elevada foi recusada.

A árvore de development foi reorganizada por responsabilidade: editores em
`editors/`, controle de versão em `version-control/` e ferramentas em `tools/`.
O módulo do Neovim agora vive em `editors/neovim/`, com seu `init.lua` ao lado.

A árvore de desktop foi reorganizada por responsabilidade: KDE em
`environments/kde`, integração em `integration`, Niri em `compositors/niri`,
Noctalia em `shells/noctalia` e o bundle agregador em `desktop-stack`.

Foram adicionados aspects opcionais mínimos para MangoWM e COSMIC. Eles não
estão incluídos no `desktop-stack`; Noctalia continua sendo a única desktop
shell configurada.

As declarações centralizadas de ambientes de desenvolvimento foram removidas;
cada projeto deve fornecer seus próprios ambientes via `flake.nix`.

## Top 3 Next Actions

- Aplicar `nh os switch .` em um ambiente com acesso ao daemon Nix.
- Confirmar que `tmux` aparece no perfil do usuário `flp`.
- Criar `flake.nix` nos projetos que precisarem de ambientes de desenvolvimento.

## Blockers

O daemon Nix está inacessível neste ambiente por permissão. Nenhum segredo
foi adicionado a arquivos rastreados.

## Current State

Referências de arquivos do repositório em módulos movíveis foram
convertidas para caminhos ancorados em `inputs.self`: avatar do SDDM,
configuração do Fastfetch, init.lua do Neovim e script de remapeamento
do Solaar. A auditoria não encontrou outras referências funcionais
relativas desse tipo.

Exceção intencional: os três imports `./_hardware.nix` dos hosts
permanecem relativos. Eles são avaliados durante a construção dos
outputs do flake; trocar por `inputs.self` causa recursão infinita.

O atalho de Ghostty no KDE também está corrigido mas ainda não foi
commitado: usa a ação `_launch` do `.desktop` real pelo grupo
`services/com.mitchellh.ghostty.desktop`, com `Meta+Return`, em vez de
uma ação inexistente do KWin.

## Top 3 Next Actions

- Aplicar `nh os switch .` e confirmar `Meta+Return` no Plasma.
- Criar commits para o atalho do Ghostty e para a refatoração de paths.
- Testar em máquina real o remapeamento M4/M5 descrito na seção abaixo.

## Blockers

Nenhum. Nenhum segredo foi adicionado a arquivos rastreados.

---

## Current State

Fix da etapa 1 (hold press/release, ver entrada abaixo de
2026-08-01) resolvia o comportamento em apps de desktop, mas M4/M5
continuavam **não funcionando dentro de jogos** (confirmado com Risk
of Rain 2 no NixOS/host `desktop`). Investigado e corrigido.

Causa raiz confirmada com `sudo libinput debug-events` rodando no
`desktop` (NixOS, não CachyOS) enquanto os botoes eram pressionados:
o Solaar emite os botoes diverted como `KEY_BACK`/`KEY_FORWARD` num
device de **TECLADO** virtual (`solaar-keyboard`, criado pelo
proprio Solaar via uinput) -- nao como botao de mouse. Apps de
desktop (browser etc) bindam essas teclas normalmente porque
`XF86_Back`/`XF86_Forward` sao convencao de teclado multimidia, mas
jogos esperam literalmente `Mouse4`/`Mouse5` (`BTN_SIDE`/`BTN_EXTRA`)
lido via evdev/raw input -- nunca reconhecem tecla como bind de mouse.
Isso e esperado ser identico em qualquer distro/compositor, nao e bug
especifico do NixOS.

Confirmado tambem, contra a documentacao oficial do Solaar
(`pwr-solaar.github.io/Solaar/rules`), que o Solaar **nao tem
capacidade nativa** de emitir botao de mouse lateral: a action
`MouseClick` das regras so cobre `left`/`middle`/`right`. Nao existe
combinacao de `rules.yaml` que resolva isso -- nao e erro de
configuracao, e limitacao da ferramenta.

Investigado (sem resolucao definitiva) por que o mesmo `rules.yaml`
(so `KeyPress`, sem nenhuma ferramenta adicional) foi validado pelo
usuario como reconhecido como "Mouse 4/5" dentro do RoR2 no CachyOS/
laptop `nitro`. Tecnicamente isso nao deveria ser possivel com o
mecanismo confirmado (teclado, nao mouse) -- permanece inconsistencia
nao explicada; hipoteses nao confirmadas: versao diferente do Solaar,
Steam Input remapeando/rotulando a tecla como "Mouse4" na UI, ou uma
config adicional que nao sobreviveu nos logs/trechos revisados. Nao
documentado como fato, so como duvida em aberto.

Fix: novo daemon (`m650l-mouse-remap.py`, `python-evdev`) que le o
device `solaar-keyboard` que o Solaar ja cria, faz `grab()` nele
(pra nao vazar como tecla pro resto do sistema, so pro daemon) e
reemite `KEY_BACK`->`BTN_SIDE`, `KEY_FORWARD`->`BTN_EXTRA` num
segundo device uinput (`m650l-mouse-buttons`), esse sim visto pelo
kernel/jogos como mouse de verdade. Roda como
`systemd.services.m650l-mouse-remap` (nivel de SISTEMA, nao user --
`/dev/uinput` e o `grab()` exclusivo de `/dev/input/eventX`
normalmente exigem acesso que `systemd.user` nao garante por padrao
sem regra udev extra). Reconecta automaticamente se o device sumir
(troca de bateria, sleep, mouse desligado/religado).

Fundido no mesmo arquivo `solaar-m650l.nix` (nao criado aspect
separado) -- e o mesmo fix conceitual (M4/M5 do M650L), so com uma
segunda etapa. `homeManager` mantem o hold (`rules.yaml` +
`solaar-m650l-divert`, ja existente); `provides.to-hosts.nixos`
ganhou o novo `systemd.services.m650l-mouse-remap` +
`services.udev.extraRules` (`uinput` com `TAG+="uaccess"`) +
`users.groups.input`/`users.flp.extraGroups`.

Ainda **nao validado em maquina real** (usuario ainda vai testar) --
proxima sessao deve confirmar com `sudo libinput debug-events`
mostrando `BTN_SIDE`/`BTN_EXTRA` (nao mais `KEYBOARD_KEY`) ao
pressionar M4/M5, e testar RoR2 direto.

## Top 3 Next Actions

- Testar em maquina real (`nh os switch`) e confirmar via
  `libinput debug-events` que M4/M5 agora saem como
  `BTN_SIDE`/`BTN_EXTRA` num device `m650l-mouse-buttons`, nao mais
  `KEYBOARD_KEY` no `solaar-keyboard`.
- Testar especificamente no RoR2 (ou outro jogo) se o bind
  "Mouse 4"/"Mouse 5" agora reconhece o input.
- Se `after = [ "graphical-session.target" ]` no servico de sistema
  nao ordenar corretamente contra o `solaar.service` (que e
  `systemd.user`, arvore separada), considerar trocar por trigger via
  regra `udev` no aparecimento do device `solaar-keyboard`, em vez de
  depender so do polling de 60s (`wait_for_source`) + `Restart=on-failure`.

## Blockers

Nenhum.

---

Last updated: 2026-08-01 23:00 UTC

## Current State

Fix do delay press->release dos botoes M4/M5 (Back/Forward) do
Logitech M650L, validado no laptop CachyOS (host `nitro`, ainda nao
migrado pra NixOS). Causa raiz: firmware HID++ trata os botoes
laterais como possivel gatilho de gesto de scroll horizontal e so
emite o evento depois de descartar o gesto -- delay reproduz identico
em Linux e Windows, independe de driver. `logiops`/`logid` (config em
`modules/apps/peripherals/logiops.nix`, incluido em `flp.nix`) nao
resolve porque so tem modo `OnRelease`, sem `OnPress`
(`PixlOne/logiops#496`); testado com `Keypress` simples no CID certo
(0x53/0x56) e o delay persiste mesmo assim.

Fix real, via Solaar: divergir (`divert-keys`) os botoes Back/Forward
pra HID++ notification em vez de evento de mouse nativo, e uma regra
(`rules.yaml`) que emite `depress`/`release` reais via `uinput`
diretamente no press/release fisico -- replica hold nativo de M1/M2.
Validado com `libinput debug-events` no CachyOS: `KEY_FORWARD pressed`
-> `released` ~1.2s depois, batendo com o tempo real que o botao ficou
pressionado.

Organizacao final: `solaar.nix` mantido generico (pacote +
`hardware.logitech.wireless`). Fix especifico do M650L em
`solaar-m650l.nix` (aspect `solaar-m650l`), separado porque e conteudo
atado ao nome/CID desse mouse -- trocar de mouse no futuro vira
"deletar um arquivo", nao "limpar lixo misturado no aspect generico".

Dependencia `solaar-m650l` -> `solaar` declarada em dois niveis:
1. `includes = [ den.aspects.solaar ]` dentro do proprio
   `solaar-m650l.nix` -- traz o aspect solaar automaticamente, sem
   exigir que quem inclui `solaar-m650l` lembre de incluir `solaar`
   tambem.
2. `assertions` em home-manager, checando se `pkgs.solaar` esta em
   `home.packages` -- rede de seguranca: se o merge de `includes`
   falhar por algum motivo estrutural do Den (framework de terceiros,
   nao nixpkgs/home-manager puro), o build FALHA com mensagem clara
   em vez de instalar rules.yaml/servico sem o daemon que os usa.

Auditado o repo inteiro por outros aspects com dependencia unica
similar (`includes = [ den.aspects.X ]`, singular): nao existe
nenhum outro caso hoje. Todos os demais usos de `includes` sao listas
agregadoras (`wm`, `dev`, `flp` etc) sem relacao de dependencia
estrita entre si -- nao ha candidato pra replicar o padrao assertions
no momento.

`flp.nix` simplificado: so lista `solaar-m650l` (nao lista mais
`solaar` separado, ja vem via includes do aspect).

config.yaml (guarda divert-keys) e escrito pelo proprio Solaar em
runtime, identificado por serial do mouse pareado
(`lib/solaar/configuration.py`) -- nao da pra declarar via
xdg.configFile sem risco de perder outro estado que o Solaar grava
sozinho (bateria etc). Solucao: versionar o COMANDO `solaar config`
(idempotente) num `systemd.user.services.solaar-m650l-divert`
(oneshot, `WantedBy graphical-session.target`, `sleep 5` + aplica
divert nos CIDs 83/86) em vez do arquivo de estado. **Zero passo
manual** -- reaplica sozinho a cada login.

`logiops.nix` continua incluido em `flp.nix` (nao removido, nao
desabilitado). No CachyOS o `logid.service` foi parado manualmente
(`systemctl status logid` confirmado `inactive/disabled`) antes de
validar o fix via Solaar -- os dois nunca foram testados rodando
simultaneamente. Sem evidencia de conflito real, apenas nao testado.
Pendencia em aberto: decidir se `logiops` deve ser removido de
`flp.nix`/deletado, ou mantido desabilitado por padrao.

---


## Current State

Investigado e corrigido `error: attribute 'sops' missing` ao rodar
`nh os switch . -u -vvv` após adicionar `apps/dev/git/github-token.nix`
com `den.aspects.git.nixos.sops.secrets...`. Causa: `git` é incluído
só do lado **user** (`flp.includes`), então a classe `nixos` desse
aspect nunca chegava no host `desktop` — `config.sops` não existe nesse
ponto de avaliação porque o aspect `secrets` (dono de `sops.*`) só é
`includes`d em `desktop`, não em `flp`. Confirmado contra a doc oficial
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
- `modules/desktop/kde/default.nix` — dono host (`desktop.includes`);
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
mesmo fora de sessão gráfica, não só ao `flp`. `hosts/desktop/default.nix`
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
