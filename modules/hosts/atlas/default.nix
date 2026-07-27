{ den, ... }: {
  den.hosts.x86_64-linux.atlas = {
    hostName = "atlas";
    kernel = "cachy";
    isLaptop = false;
    users.flp = {
      isGaming = true;
    };
  };

  den.aspects.atlas = {
    includes = with den.aspects; [
      den.provides.hostname

      grub
      kernel
      essential
      security
      secrets
      (ssh-identity-for { user = "flp"; })

      kde
      astah
      sql-power-architect
      flatpak

      { nixos = import ./_hardware.nix; }
    ];

    provides.to-users.includes = with den.aspects; [
      identities
      essential
    ];
  };
}
