{
  den.aspects.fish = {
    nixos = {
      stylix.targets.fish.enable = true;

      programs.fish.enable = true;
    };

    homeManager = { pkgs, ... }: {
      stylix.targets.fish.enable = true;

      programs.fish.enable = true;

      home.packages = with pkgs; [
        hwinfo
      ];
    };
  };
}
