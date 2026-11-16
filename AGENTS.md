# AGENTS.md

## Start of session

1. Read `README.md`, then `HANDOFF.md`.
2. Inspect `git status` and relevant diffs before editing; preserve unrelated
   user changes.

## Approval and uncertainty

- Reading and investigating need no approval. Before editing files, running
  state-changing commands, or committing, present the plan and wait for
  explicit approval; it covers only what was presented.
- Before anything that can discard work (`reset`, `checkout --`, `stash`,
  `rebase`, merge, deleting files or branches), list what exists only locally
  and create a local backup branch (never pushed); delete it once the
  operation is confirmed.
- When in doubt, ask. Base decisions on authoritative sources (upstream docs,
  module source, `--help`) and never present unverified claims as fact. A rule
  here that depends on upstream behavior cites its source (URL or path plus a
  short quote) and the date it was verified.

## Working principles

- Make the smallest coherent change. When removing or replacing something,
  also remove what it leaves unused; no half-migrated scaffolding or
  commented-out leftovers. Commented options kept as reference (alternative
  values, settings to turn on later) are allowed.
- Never remove or disable a package, aspect, or feature the user chose to
  work around a problem (build cost, cache miss, breakage) unless the user
  asks; propose fixes that keep it.
- Default to zero comments; one or two short lines only for a non-obvious WHY.
  Rationale goes in commit messages.
- Group bindings that share a prefix: `x = { y = ...; z = ...; };`, never
  `x.y = ...; x.z = ...;` in the same attrset.
- In an aspect, each class is its own binding opening a block (`nixos = {`,
  also `homeManager` and under `provides.*`), never `nixos.programs.x = ...`
  or `den.aspects.x.nixos = ...`. A function class keeps its head on one line
  (`nixos = { pkgs, ... }: {`) unless nixfmt splits it (body starting with
  `let`, multi-line formals). A block identical in both classes is bound once
  in a `let` and assigned to each (`nixos = fish; homeManager = fish;`).
- Layout is owned by `nix fmt -- <changed .nix files>` (nixfmt default mode);
  it keeps given line breaks, so write the layout above and never
  hand-format against it. The `nix-style` hook (ast-grep) reports violations.
- Keep the system declarative and reproducible from tracked files. Reuse
  existing aspects, options, packages, and helpers before adding new ones.
- Recommend the best target architecture impartially; weigh migration effort
  only when planning the implementation.
- Durable rules go here; current state goes in `HANDOFF.md`. After significant
  decisions or unfinished work, rewrite `HANDOFF.md` whole (under ~60 lines):
  UTC timestamp, current state, up to three next actions, blockers, and
  confirmation that no secrets were added.

## Architecture invariants

- Dendritic pattern via Den on flake-parts. Every `.nix` file under `modules/`
  is auto-imported by `import-tree`; directories organize but do not wire
  imports. Preserve `flake-parts.lib.mkFlake` + `import-tree`; no raw
  `evalModules`.
- Classes: `nixos` and `homeManager`. NixOS hosts declare their users
  (`users.<name> = { }`) and `den.schema.user.classes` gives them
  `homeManager`, so `nh os switch` builds system and home together. Hosts
  without NixOS use standalone `den.homes` (`nh home switch`) with the same
  user aspect.
- Use documented Den APIs: no invented `_module.args`, no overwriting
  `config.den.aspects`, no `specialArgs`/`extraSpecialArgs`; read `inputs` and
  `self` from the top-level module. Check Den batteries before building
  custom infrastructure; name them `den.batteries.<name>`, not `den.provides`
  or `den._`.

## Aspect ownership and routing

- The entity that includes an aspect owns it. The plain `nixos` of a
  user-owned aspect reaches every host the user lives on through
  `den.batteries.user-aspects` (in `den.schema.host.includes`); use
  `provides.to-hosts` or `provides.<host>` only to target a named host or read
  `{ host }`. Without the battery it arrives only through Den's transition
  default, which ends 2027-01-01. Source: Den's
  `docs/src/content/docs/explanation/crossing-scopes.mdx` ("Lets a host
  accept everything its users produce for it, as before #694. While the
  transition defaults are on, it is on by default; include it explicitly to
  keep it."); verified 2026-11-16.
- The plain `homeManager` of a host-owned aspect needs `provides.to-users`
  (or a named user provider) or `host-aspects` to reach users; other classes,
  such as `user`, always need `provides.to-users`.
- Host-integrated users inherit the host's `provides.to-users`; do not add a
  `provides.<host>` for them. A standalone home `<user>@<host>` does not, and
  resolves the user aspect plus its `provides.<host>`.
- `den.batteries.host-aspects` (in `den.schema.user.includes`) gives host
  users the plain `homeManager` of the host's own `includes`, but not of
  `den.schema.host.includes`, which need `provides.to-users`. Source: Den's
  `modules/aspects/batteries/host-aspects.nix` ("Projects all `user.classes`
  like `homeManager` from the host's aspect tree onto users who opt in");
  verified 2026-11-15.
- Baselines live only in `modules/defaults.nix`: `den.default.includes` for
  what applies alike to hosts, users and homes; `den.schema.{host,user,home}`
  for the rest. Host-only aspects and `{ host }` functions never go in
  `den.default`, which also walks every user and home.
- `modules/system/essential/` is one aspect split across files: extend
  `den.aspects.essential`.

## Generated flake

- `flake.nix` is generated; never edit it. Core inputs go in
  `modules/flake/inputs.nix`, others in the consuming module via
  `flake-file.inputs`; keep the dendritic `flake-file.outputs` preset. After
  changing inputs, run `nix run .#write-flake` and review the diff.
- Never edit `flake.lock` by hand; use `nix flake update [<input>]`, review the
  diff, and keep lock updates separate from activation.
- Flakes ignore untracked files: track or stage every new file.

## Directory responsibilities

- `modules/flake/` core inputs and outputs; `modules/defaults.nix` baselines
  (entity options live with the aspect that reads them); `modules/tooling/`
  formatter, checks, dev shell, hooks; `modules/applications/` software a
  person selects (`peripherals/` for software tied to a device);
  `modules/features/` capabilities independent of an app (`graphical`,
  `stylix`); `modules/system/` base of every NixOS machine, even headless;
  `modules/desktop/` environments, compositors, shells and session stacks;
  `modules/hosts/` boot, hardware and desktop choices (never edit generated
  `_hardware.nix`); `modules/users/` per-user apps and preferences.
- Name each file after its aspect. An aspect split across files gets a
  directory with `default.nix` as entry; the directory may be dropped from the
  name (`system/kernel/cachy.nix` defines `cachy-kernel`). A host option that
  picks among a directory's aspects lives there as `<option>-schema.nix`.
- Directories are plural for interchangeable items (`browsers/`,
  `compositors/`) and singular for a domain (`development/`, `gaming/`).
- A main directory may have a short `README.md`; keep it in sync. In docs,
  write `name/` and `name.nix` in backticks, relative to the README's
  directory inside one, to the repository root elsewhere.

## Packages and inputs

- Keep application policy in the consuming aspect, not in `essential`.
- `stylix.nix` imports Stylix with `autoEnable = false` and enables only the
  base targets no other aspect owns (gtk, qt, x11, fonts, icons). The theme
  lives in the user aspect (`modules/users/flp/theme.nix`), which sends it to
  the host through its plain `nixos`. Every other target is enabled in the
  aspect that owns the app; an app without a target reads `config.stylix.*`.
- Install through `programs.<name>`/`services.<name>` (matching the class)
  when one exists; otherwise `environment.systemPackages` or `home.packages`.
- Scope insecure-package exceptions to the smallest package set and consumer,
  with the reason beside it. Do not pin old releases to hide insecurity
  markers or override major versions without validating.
- A project locked more than once follows the root input when compatible (a
  transitive input this config does not use must leave every host's
  `drvPath` unchanged; `nixpkgs` never follows when the input's cache was
  built against its own pin). Otherwise register it in
  `flake-duplicates.allowed` with the reason; the hook reports the rest.
- Setting `nix.settings.substituters` replaces the defaults; always keep
  `https://cache.nixos.org/`. `nix-settings.nix` lists only general caches.
- Keep everything an aspect needs in its own module, so deleting it leaves no
  remnants. Its binary cache goes in the same file, as
  `den.aspects.essential.nixos.nix.settings.{substituters,trusted-public-keys}`.
  Never use flake `nixConfig` or `accept-flake-config`; `bootstrap.sh` passes
  the host's caches to the first build.

## Local builds

- Before building, switching, or activating Home Manager, dry-run
  (`--dry-run --no-link --no-write-lock-file`) and inspect what would build.
- Light builds are acceptable: config, metadata and wrappers, and small
  packages that compile in a few minutes; list them in the plan.
- Heavy builds (large toolchains, browsers, kernels, long dependency chains)
  need approval: report package, consumer, and caches consulted, and offer, in
  order: a trusted substitute; an official binary; a cached revision (for a
  flake input, an always-cached upstream branch such as `noctalia`'s
  `cachix`, else release tags newest-first with `--option max-jobs 0`); a
  remote builder; accepting the build. Never drop the package (see Working
  principles).
- Never claim a revision is cached without checking its exact derivation.
- Activation is atomic; never omit a missing dependency to force a switch.

## Validation

Validate the smallest meaningful target, then integration in proportion to the
change. A dry-run is a preflight, not proof of runtime correctness.

- Nix/module changes: `nix flake check --no-build --no-write-lock-file`.
- Packages: dry-run the package output.
- Home Manager-only: dry-run `homeConfigurations.<user@host>.activationPackage`.
- NixOS, routing, shared inputs, overlays, package sets: dry-run
  `config.system.build.toplevel` of every host whose graph can change.
- Tooling: run `nix-direnv-reload` before committing (`.envrc` uses
  `nix_direnv_manual_reload`), or the old hooks run.
- Do not add package outputs just to make aspects buildable, and do not run
  `switch`, `boot`, or other activation unless the user asks.

## Secrets

- Never put plaintext secrets in tracked files or command output.

## Git and commits

- Review status and diffs; stage explicit paths.
- One goal per commit, as few commits as that allows: a change goes with the
  check, `AGENTS.md`, README or `HANDOFF.md` lines that belong to it. Never
  split one file's hunks across commits of the same goal.
- Messages in Portuguese, `escopo: resumo no imperativo` (checked by
  `commit-msg-style`): lowercase aspect, module or area (`nh`,
  `hosts/aspire`, `agents`), several joined with `, `; subject ≤ 72
  characters, no final period; a body explaining why and the impact.
- Before the first commit, present every message and its paths for approval.

## References

- Dendritic: https://github.com/mightyiam/dendritic
- Den: https://den.denful.dev/explanation/core-principles/,
  https://den.denful.dev/reference/batteries/,
  https://den.denful.dev/guides/mutual/
