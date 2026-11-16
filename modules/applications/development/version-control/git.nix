let
  git = {
    programs.git.enable = true;
  };
in
{
  den.aspects.git = {
    nixos = git;
    homeManager = git;
  };
}
