_: {
  den.aspects.essential = {
    nixos = {
      # Desabilitado por padrão — ativar por host quando quiser,
      # com `lib.mkForce true` no host específico.
      system.autoUpgrade = {
        enable = false;
        allowReboot = false;
        flake = "github:felipeasop/nixos-config";
        dates = "weekly";
      };
    };
  };
}
