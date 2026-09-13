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
        home.stateVersion = "26.05";
        home.packages = [ pkgs.nh ];

        # Usado por comandos avulsos, como `nix run nixpkgs#<pacote>`.
        xdg.configFile."nixpkgs/config.nix".text = ''
          { allowUnfree = true; }
        '';
      }
      // lib.optionalAttrs (osConfig == null) {
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
