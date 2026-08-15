{ den, ... }: {
  den.hosts.x86_64-linux.nitro = {
    hostName = "nitro";
    kernel = "cachy";
    users.flp = { };
  };

  den.aspects.nitro = {
    includes = with den.aspects; [
      den.provides.hostname

      systemd-boot
      standard-host
      secrets
      (ssh-identity-for { user = "flp"; })

      kde
      flatpak

      nvidia
      laptop

      { nixos = import ./_hardware.nix; }
    ];

    provides.to-users.includes = with den.aspects; [
      essential
    ];
  };
}
