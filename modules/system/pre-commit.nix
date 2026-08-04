{ inputs, ... }: {
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem = { lib, self', ... }: {
    pre-commit.settings.hooks = {
      treefmt = {
        enable = true;
        entry = lib.mkForce (lib.getExe self'.formatter);
      };
      deadnix.enable = true;
      statix = {
        enable = true;
        # _hardware.nix é autogerado pelo nixos-generate-config
        # (cabeçalho "DO NOT MODIFY")
        # Excluído por padrão de nome, cobre qualquer host
        excludes = [ "_hardware\\.nix$" ];
      };
    };
    pre-commit.check.enable = false;
  };
}
