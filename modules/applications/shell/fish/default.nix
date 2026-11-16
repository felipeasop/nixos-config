let
  fish = {
    stylix.targets.fish.enable = true;

    programs.fish.enable = true;
  };
in
{
  den.aspects.fish = {
    nixos = fish;
    homeManager = fish;
  };
}
