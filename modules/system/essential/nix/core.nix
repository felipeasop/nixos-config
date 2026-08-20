{ inputs, ... }: {
  den.aspects.essential = {
    nixos.system.stateVersion = "26.05";
    homeManager = {
      home.stateVersion = "26.05";

      # Usado por comandos avulsos, como `nix run nixpkgs#<pacote>`.
      xdg.configFile."nixpkgs/config.nix".text = ''
        { allowUnfree = true; }
      '';
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
