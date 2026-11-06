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
      secrets
      (ssh-identity-for { user = userName; })

      solaar-m650l

      kde
      niri-stack
      desktop-apps

      { nixos = import ./_hardware.nix; }
    ];

    # host-aspects (flp.nix) só projeta o que está no includes escrito à mão;
    # essential chega via den.schema.host.includes, invisível pra battery.
    provides.to-users.includes = with den.aspects; [ essential ];
  };
}
