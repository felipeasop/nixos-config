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

      secrets
      (ssh-identity-for { user = "flp"; })

      kde

      { nixos = import ./_hardware.nix; }
    ];

    # O schema resolve a fatia NixOS de `essential` no host; esta rota entrega
    # sua fatia Home Manager ao usuário (incluindo home.stateVersion).
    provides.to-users.includes = with den.aspects; [
      essential
    ];
  };
}
