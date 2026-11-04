{ inputs, ... }:
{
  # Cobre `nix run/build/shell <flake>#pkg` ad-hoc (flakes avaliam puro; não leem config.nix/NIXPKGS_ALLOW_UNFREE sem --impure).
  perSystem = { system, ... }: {
    legacyPackages = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  };
}
