{ inputs, lib, ... }: {
  den.aspects.essential = {
    nixos.system.stateVersion = "26.05";
    homeManager =
      {
        pkgs,
        osConfig ? null,
        ...
      }:
      {
        home = {
          stateVersion = if osConfig != null then osConfig.system.stateVersion else "26.05";
          packages = [ pkgs.nh ];
        };

        # Só comandos legados sem flake (nix-shell -p, nix-env); nix run é coberto por unfree-packages.nix.
        xdg.configFile."nixpkgs/config.nix".text = ''
          { allowUnfree = true; }
        '';
      }
      // lib.optionalAttrs (osConfig == null) {
        # Só pra home standalone (sem NixOS por trás)
        nixpkgs.config.allowUnfree = true;
      };
    nixos = {
      imports = [ inputs.home-manager.nixosModules.default ];
      nixpkgs.config.allowUnfree = true;
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-bak";
      };
    };
  };
}
