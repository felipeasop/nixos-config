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
  `rebase`, merge, deleting files or branches), create a backup branch and list
  what exists only locally.
- When in doubt, ask. Base decisions on authoritative sources (upstream docs,
  module source, `--help`) and cite them; never present unverified claims as
  fact.

## Working principles

- Make the smallest coherent change. When removing or replacing something,
  also remove the inputs, options, packages, and bindings it leaves unused; no
  commented-out blocks or half-migrated scaffolding.
- Default to zero comments. Add one or two short lines only for a non-obvious
  WHY (hidden constraint, bug workaround). Rationale goes in commit messages.
- Layout is owned by `nix fmt` (nixfmt in strict mode, also run by the
  pre-commit hook). Run `nix fmt -- <changed .nix files>` and never
  hand-format against its output.
- Keep the system declarative and reproducible from tracked files. Reuse
  existing aspects, options, packages, and helpers before adding new ones.
- Recommend the best target architecture impartially; consider migration
  effort only when planning the implementation.
- Durable rules go here; current state goes in `HANDOFF.md`. After significant
  decisions or unfinished work, rewrite `HANDOFF.md` whole: UTC timestamp,
  current state, up to three next actions, blockers, and confirmation that no
  secrets were added. Keep it under ~60 lines.

## Architecture invariants

- Dendritic pattern via Den on flake-parts. Every `.nix` file under `modules/`
  is auto-imported by `import-tree`; directories organize but do not wire
  imports (relative paths and colocated assets still depend on location).
- Preserve the `flake-parts.lib.mkFlake` + `import-tree` pipeline; no raw
  `evalModules`.
- Module classes: `nixos` and `homeManager`. NixOS hosts declare the user with
  `classes = [ "homeManager" ]`, so `nh os switch` builds system and home in
  one generation. Hosts without NixOS use standalone `den.homes` (`nh home
  switch`). The user aspect is the same either way.
- Use documented Den APIs. Do not invent `_module.args`, overwrite
  `config.den.aspects`, or pass values with `specialArgs`/`extraSpecialArgs`;
  read `inputs` and `self` from the top-level module. Check Den batteries before
  building custom infrastructure.

## Aspect ownership and routing

- The entity that includes an aspect owns it. A host-owned aspect routes Home
  Manager config with `provides.to-users` (or a named user provider); a
  user-owned aspect routes NixOS config with `provides.to-hosts` (or a named
  host provider). Without the matching provider, the minority-class
  contribution may be silently unreachable.
- A host-integrated user (`classes = [ "homeManager" ]`) inherits the host's
  `provides.to-users` automatically; do not add a `provides.<host>` provider
  for it. A standalone home `<user>@<host>` does not inherit them and resolves
  the user aspect plus its `provides.<host>` provider.
- Baselines live only in `den.schema.{host,user,home}.includes`
  (`modules/den/schema/entity-defaults.nix`).
- `system/essential/` is one aspect split across files: extend
  `den.aspects.essential`, do not create per-file aspects.

## Generated flake

- `flake.nix` is generated; never edit it. Core inputs go in
  `modules/flake/inputs.nix`; other inputs go in the consuming module via
  `flake-file.inputs`. Keep the dendritic `flake-file.outputs` preset.
- After changing `flake-file.inputs`, run `nix run .#write-flake`, review the
  diff, and stage only the generated paths required.
- Never edit `flake.lock` by hand; use `nix flake update [<input>]`, review the
  diff, and keep lock updates separate from activation.
- Flakes ignore untracked files: track or stage everything a flake references.

## Directory responsibilities

- `modules/flake/`: core inputs and output generation.
- `modules/den/`: Den integration, entity schema, entity options.
- `modules/tooling/`: formatter, static analysis, dev shell, hooks.
- `modules/applications/`: software a person selects and uses;
  `applications/hardware/peripherals/` for software tied to a peripheral.
- `modules/features/`: system or hardware capabilities independent of an app.
- `modules/hosts/`: host boot, hardware, and desktop choices. Never edit
  generated `_hardware.nix`.
- `modules/users/`: per-user apps and preferences beyond the baseline.

## Packages and inputs

- Keep application policy in the consuming aspect, not in `essential`.
- Scope insecure-package exceptions to the smallest package set and consumer,
  with the consumer and reason beside it. Do not pin old releases to hide
  insecurity markers or override major versions without validating.
- Use `inputs.<name>.inputs.nixpkgs.follows = "nixpkgs"` only when compatible;
  never when the input's cache was built against its own nixpkgs pin.
- Setting `nix.settings.substituters` replaces the defaults; always keep
  `https://cache.nixos.org/`. `nix-settings.nix` lists only general caches.
- Keep everything an aspect needs in its own module, so deleting it leaves no
  remnants. Its binary cache goes in the same file, as
  `den.aspects.essential.nixos.nix.settings.{substituters,trusted-public-keys}`,
  so it is registered on every host before the aspect is included. Never use
  flake `nixConfig` or enable `accept-flake-config`; `bootstrap.sh` passes the
  host's caches to the first build.

## Binary-substitute policy

- MUST NOT compile software locally. Before building, switching, or activating
  Home Manager, dry-run (`--dry-run --no-link --no-write-lock-file`) and
  inspect the plan.
- If software would be built locally, stop and report the package,
  derivation, consumer, and caches consulted. Prefer, in order: a trusted
  substitute; an official binary distribution; a proven cached revision; a
  remote builder/cache; excluding the consumer after approval.
- For a flake input that would compile, first look for an always-cached
  upstream branch (e.g. `noctalia`'s `cachix`); otherwise test release tags
  newest-first with `--option max-jobs 0` and pin the first fully cached one.
- Never claim a revision is cached without checking its exact derivation.
- Local derivations that only compose config, generate metadata, or wrap
  binaries are fine; they may not run a toolchain to produce the application.
- Activation is atomic; never omit a missing dependency to force a switch.

## Validation

Validate the smallest meaningful target, then integration in proportion to the
change. A dry-run is a preflight, not proof of runtime correctness.

- Docs only: formatting or link checks when relevant.
- Nix/module changes: `nix flake check --no-build --no-write-lock-file`.
- Packages: dry-run the package output; build only if it complies with the
  binary-substitute policy.
- Home Manager-only: dry-run `homeConfigurations.<user@host>.activationPackage`.
- NixOS, routing, shared inputs, mixed-class, overlays, package sets: evaluate
  `config.system.build.toplevel` of every host whose graph can change.
- Do not add package outputs just to make aspects buildable.
- Do not run `switch`, `boot`, or other activation unless the user asks.

## Secrets

- Never put plaintext secrets in tracked files or command output.

## Git and commits

- Review status, unstaged and staged diffs; stage explicit paths; one
  responsibility per commit.
- Messages in Portuguese, `escopo: resumo no imperativo` (checked by the
  `commit-msg-style` hook). Scope is the lowercase aspect, module, or area
  (`nh`, `hosts/aspire`, `agents`), several joined with `, `. Subject ≤ 72
  characters, no final period. A body explaining why and the impact is
  required.
- Before the first commit, present every message and its paths for approval.

## References

- Dendritic: https://github.com/mightyiam/dendritic
- Den: https://den.denful.dev/explanation/core-principles/,
  https://den.denful.dev/reference/batteries/,
  https://den.denful.dev/guides/mutual/
