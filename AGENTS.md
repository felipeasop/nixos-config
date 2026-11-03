# AGENTS.md

Instructions for agents working in this repository. User and system instructions
take precedence.

## Start of session

1. Read `README.md`, then `HANDOFF.md`.
2. Inspect `git status` and relevant diffs before editing.
3. Preserve unrelated user changes in a dirty worktree.

## Working principles

- Make the smallest coherent change that satisfies the request.
- Default to zero comments. Add one only when the WHY is genuinely
  non-obvious (a hidden constraint, a workaround for a specific bug,
  something that would surprise a reader) — one or two short lines, never a
  multi-line block or a restatement of what the code already says. Put
  investigation, rationale, and alternatives considered in chat/commit
  messages, not in the file.
- Keep the system declarative and reproducible from tracked files.
- Reuse existing aspects, options, packages, and helpers before adding new ones.
- When evaluating architectural alternatives, recommend the best target
  architecture impartially. Do not favor the current architecture or let
  migration effort influence the recommendation; consider migration friction
  only when planning how to implement the chosen architecture.
- Put durable repository rules here. Put current state, investigations, and next
  actions in `HANDOFF.md`.
- Update `HANDOFF.md` after significant decisions or unfinished work, not for
  trivial or documentation-only changes. Include the UTC timestamp, current
  state, up to three next actions, blockers, and confirmation that no secrets
  were added to tracked files.

## Architecture invariants

- This repository follows the dendritic pattern implemented by Den on top of
  flake-parts.
- Every `.nix` file under `modules/` is imported automatically by `import-tree`.
  Directory names organize the repository but do not wire imports. Relative
  paths and colocated assets still make file location relevant.
- Preserve the top-level `flake-parts.lib.mkFlake` plus `import-tree` pipeline.
  Do not replace it with a raw `evalModules` setup.
- The active module classes are `nixos` and `homeManager`.
- Home Manager instantiation depends on whether the host runs NixOS:
  - NixOS hosts give the host-declared user `classes = [ "homeManager" ]`
    (see `modules/hosts/desktop/default.nix`). Den then imports the Home
    Manager NixOS module and forwards that user's `homeManager` content into
    `home-manager.users.<name>` automatically, so `nh os switch` rebuilds
    system and home together in one generation.
  - Hosts without a NixOS system (e.g. a future Fedora host) use standalone
    `den.homes` outputs instead, activated separately via `nh home switch` /
    the `home-manager` CLI.
  - The user aspect itself (e.g. `flp`) stays identical either way; only the
    per-host `classes`/`den.homes` declaration changes which activation path
    consumes it.
- An entity is a host, user, or standalone home. An aspect is a composable unit
  that may contribute modules to either class. Batteries are reusable
  Den-provided patterns.
- Use documented Den APIs. Do not invent `_module.args`, overwrite
  `config.den.aspects`, or use `specialArgs`/`extraSpecialArgs` to pass values
  between repository modules. Read shared values such as `inputs` and `self`
  from the top-level module configuration.
- Check Den batteries before implementing custom infrastructure already covered
  upstream.

## Aspect ownership and routing

- The entity that includes an aspect owns it.
- A host-owned aspect that contributes Home Manager configuration MUST route
  that contribution with `provides.to-users` or a named user provider.
- A user-owned aspect that contributes NixOS configuration MUST route that
  contribution with `provides.to-hosts` or a named host provider.
- A standalone home named `<user>@<host>` resolves the user aspect plus its
  named `provides.<host>` provider. Host `provides.to-users` contributions are
  not inherited automatically; reuse them from that named user provider.
- A host-declared user with `classes = [ "homeManager" ]` (NixOS/Darwin
  integration) DOES inherit that host's `provides.to-users` contributions
  automatically. Do not add a named `provides.<host>` provider for a
  host-integrated user; that pattern exists only to compensate for standalone
  homes.
- A mixed-class aspect without the matching provider is incomplete: its
  minority-class contribution may be silently unreachable.
- `den.schema.host.includes` is the single host baseline and currently contains
  `essential`, `security`, `kernel`, `kernel-tuning`, and `flatpak`.
- `den.schema.user.includes` is the single user baseline and currently contains
  `define-user`, `primary-user`, and `(user-shell "fish")`.
- `den.schema.home.includes` is the standalone-home baseline and currently
  contains `define-user`, `essential` (including `nh`), and
  `(user-shell "fish")`.
- `system/essential/` is intentionally one aspect split across files. Extend
  `den.aspects.essential`; do not create one aspect per file there.
- `gaming-stack` is user-owned and routes its NixOS contributions to related
  hosts through `provides.to-hosts`.

## Generated flake

- `flake.nix` is generated and MUST NOT be edited manually.
- Declare core inputs in `modules/flake/inputs.nix`. Declare non-core inputs in
  the module that consumes them through `flake-file.inputs`.
- Do not manually replace the dendritic `flake-file.outputs` preset.
- After changing `flake-file.inputs`, run `nix run .#write-flake`, review the
  generated diff, and stage only the generated paths required by the change.
- Never edit `flake.lock` manually. Update it with `nix flake update` or
  `nix flake update <input>` and review the diff.
- Files referenced by a flake must be tracked or staged because flakes ignore
  untracked source files.

## Directory responsibilities

- `modules/flake/`: fundamental flake inputs and output generation.
- `modules/den/`: Den integration, entity schema, and repository-specific entity
  options.
- `modules/tooling/`: formatter, static analysis, development shell, and hooks.
- `modules/applications/`: software directly selected and used by a person.
- `modules/features/`: system or hardware capabilities that remain meaningful
  independently of a particular application.
- `modules/applications/hardware/peripherals/`: software coupled to a selected
  peripheral, even when it controls hardware.
- `modules/hosts/`: host-specific boot, hardware, secrets, and desktop choices.
  Never manually edit generated `_hardware.nix` files.
- `modules/users/`: user-specific applications and preferences beyond the shared
  baseline.

## Packages, inputs, and exceptions

- Keep application-specific policy in the consuming application aspect, not in
  the global `essential` aspect.
- Scope insecure-package exceptions to the smallest package set and consumer.
  Record the consumer and reason beside the exception.
- Do not pin an older release merely to hide an insecurity marker or override a
  dependency's major version without validating compatibility.
- Use `inputs.<name>.inputs.nixpkgs.follows = "nixpkgs"` when sharing nixpkgs is
  compatible with that input. Do not force `follows` when an upstream cache was
  built against its own nixpkgs pin, because doing so changes derivation hashes
  and can cause cache misses.
- Declaring `nix.settings.substituters` replaces the default list. Always retain
  `https://cache.nixos.org/` alongside trusted additional caches.

## Binary-substitute policy

- MUST NOT compile software packages locally from source.
- Keep substitution enabled and inspect the realization plan before building,
  updating the running system, or activating Home Manager.
- If a software package would be built locally, stop before realization and
  report the package, derivation, relevant consumer, and caches consulted.
- Prefer, in order: an existing trusted substitute; an official fixed-output
  binary distribution; a proven cached revision; a remote builder/cache; or
  temporarily excluding the consumer after user approval.
- Never claim a revision is cached without checking its exact derivation.
- Local derivations that only compose configuration, generate metadata, or wrap
  existing binaries are expected. They may not invoke a software toolchain to
  produce the distributed application.
- NixOS activation is atomic. Do not attempt a partial switch that omits a
  missing dependency from the evaluated closure.
- Update locks separately from activation. Avoid combining an unreviewed input
  update with `switch`.

## Validation strategy

Validate the smallest meaningful target first, then validate integration in
proportion to the change.

- An aspect is a module contribution, not normally a standalone derivation. Do
  not add artificial package outputs solely to make every aspect buildable.
- Documentation-only changes: run formatting or link checks when relevant.
- Nix syntax/module changes: run `nix flake check --no-build
  --no-write-lock-file`.
- Package changes: dry-run the affected package output first, then build that
  package only if the plan complies with the binary-substitute policy.
- Home Manager-only changes: evaluate or dry-run the affected standalone
  `homeConfigurations.<user@host>.activationPackage`.
- NixOS, routing, shared-input, or mixed-class changes: evaluate the affected
  host's `config.system.build.toplevel`; test every host whose graph can change.
- Before realization, use `--dry-run`, `--no-link`, and
  `--no-write-lock-file` where supported. A dry-run is a preflight, not proof of
  runtime correctness.
- A targeted check does not replace final integration validation when the change
  affects module composition, providers, overlays, package sets, or shared
  inputs.
- Do not run `switch`, `boot`, or other activation commands unless the user
  requested system activation.

Nix builds only changed derivations and reuses valid store paths and substitutes.
A full system target therefore validates integration without necessarily
rebuilding unrelated software.

## Secrets

- Secrets are managed with `sops-nix`; never place plaintext secrets in tracked
  files or command output.
- Host decryption uses `/etc/ssh/ssh_host_ed25519_key`.
- Host-specific encrypted values live in `secrets/secrets.yaml` and recipients
  are declared in `.sops.yaml`.
- Follow `secrets/README.md` for provisioning or rotating hosts and identities.
- Reuse `config.networking.hostName` instead of duplicating host identity in
  secret paths or aspect parameters.

## Git and commits

- Review `git status`, unstaged diffs, and staged diffs before committing.
- Stage explicit paths for each logical change; do not mix unrelated work.
- Use Portuguese Conventional Commits:
  `type(scope): resumo no imperativo`.
- Each commit needs a short subject and a Portuguese body explaining purpose and
  user/system impact.
- Separate distinct responsibilities into independent commits.
- Before the first commit, present the complete commit plan with messages and
  paths, then wait for user approval.

## Authoritative references

- Dendritic pattern: https://github.com/mightyiam/dendritic
- Den principles: https://den.denful.dev/explanation/core-principles/
- Den batteries: https://den.denful.dev/reference/batteries/
- Den mutual providers: https://den.denful.dev/guides/mutual/
- Operational commands: `README.md`
- Current repository state: `HANDOFF.md`
