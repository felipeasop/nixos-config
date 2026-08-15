{ den, ... }: {
  den.hosts.x86_64-linux.desktop = {
    hostName = "desktop";
    kernel = "cachy";
    users.flp = { };
  };

  den.aspects.desktop = {
    includes = with den.aspects; [
      den.provides.hostname

      grub
      amd-graphics
      gaming

      standard-host
      secrets
      (ssh-identity-for { user = "flp"; })

      kde
      flatpak

      { nixos = import ./_hardware.nix; }
    ];

    provides.to-users.includes = with den.aspects; [
      essential
    ];
  };
}
