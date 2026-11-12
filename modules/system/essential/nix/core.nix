{ inputs, self, ... }: {
  den = {
    schema.home = { home, ... }: { pkgs = self.legacyPackages.${home.system}; };

    aspects.essential = {
      homeManager =
        {
          lib,
          pkgs,
          osConfig ? null,
          ...
        }:
        {
          home = {
            stateVersion = if osConfig != null then osConfig.system.stateVersion else "26.05";
            # Em host NixOS o nh já vem do programs.nh do sistema.
            packages = lib.optional (osConfig == null) pkgs.nh;
          };

          # Só comandos legados sem flake (nix-shell -p, nix-env); nix run é coberto por unfree-packages.nix.
          xdg.configFile."nixpkgs/config.nix".text = ''
            { allowUnfree = true; }
          '';
        };

      nixos = {
        system.stateVersion = "26.05";
        imports = [ inputs.home-manager.nixosModules.default ];
        nixpkgs.config.allowUnfree = true;
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "hm-bak";
          overwriteBackup = true;
        };
      };
    };
  };
}
