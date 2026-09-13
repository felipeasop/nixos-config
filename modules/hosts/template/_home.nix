let
  system = "x86_64-linux";
  hostName = "host";
  userName = "user";
in
{
  den.homes.${system}."${userName}@${hostName}" = { };

  den.aspects.${userName}.provides.${hostName}.homeManager = {
    targets.genericLinux.enable = true;
  };
}
