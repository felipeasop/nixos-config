{ den, ... }:
let
  system = "x86_64-linux";
  hostName = "desktop";
  userName = "flp";
in
{
  den.hosts.${system}.${hostName} = {
    kernel = "cachy";
    users.${userName}.classes = [ "homeManager" ];
  };

  den.aspects.${hostName} = {
    includes = with den.aspects; [
      den.provides.hostname

      grub
      amd-graphics

      solaar-m650l

      secrets
      (ssh-identity-for { user = userName; })

      kde

      { nixos = import ./_hardware.nix; }
    ];

    provides.to-users.includes = with den.aspects; [
      essential
      solaar-m650l
    ];
  };
}
