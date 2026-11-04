{
  den.aspects.essential = {
    nixos = { pkgs, ... }: {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 5d --keep 3 --nogc-roots --all";
          dates = "weekly";
        };
      };
      environment.systemPackages = [ pkgs.nix-output-monitor ];
    };

    homeManager = { config, ... }: {
      home.sessionVariables.NH_FLAKE = "${config.home.homeDirectory}/nixos-config";
    };
  };
}
