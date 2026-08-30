{ den, ... }: {
  # WIP: manter desabilitado até adicionar o `_hardware.nix` real gerado na
  # máquina alvo. Este diretório ainda não contém configuração de hardware.
  # den.hosts.x86_64-linux.nitro = {
  #   hostName = "nitro";
  #   kernel = "cachy";
  # };

  den.aspects.nitro = {
    includes = with den.aspects; [
      den.provides.hostname

      systemd-boot
      secrets
      (ssh-identity-for { user = "flp"; })

      kde

      nvidia
      laptop

      { nixos = import ./_hardware.nix; }
    ];

    # O schema resolve a fatia NixOS de `essential` no host; esta rota entrega
    # sua fatia Home Manager ao usuário (incluindo home.stateVersion).
    provides.to-users.includes = with den.aspects; [
      essential
    ];
  };
}
