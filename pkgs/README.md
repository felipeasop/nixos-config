# pkgs/by-name

Pacotes locais (derivations que não estão no nixpkgs). Cada subpasta com
um `default.nix` vira `packages.<nome-da-pasta>` automaticamente, via
`pkgs-by-name-for-flake-parts` (registrado em
`modules/flake-parts/flake-file.nix`).

Uso: `nix build .#<nome-da-pasta>`.

Apague `exemplo-pacote/` quando adicionar o primeiro pacote de verdade.
