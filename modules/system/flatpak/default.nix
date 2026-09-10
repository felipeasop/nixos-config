{ inputs, lib, ... }: {
  flake-file.inputs.nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

  den.aspects.flatpak = {
    nixos = {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

      xdg.portal = {
        enable = true;
        config.common.default = lib.mkDefault "*";
      };

      services.flatpak = {
        enable = true;
        uninstallUnmanaged = true;

        update = {
          onActivation = true;
          auto = {
            enable = true;
            onCalendar = "weekly";
          };
        };
      };
    };
  };
}
