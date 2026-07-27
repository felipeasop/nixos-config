{ den, ... }: {
  # Copie esta pasta pra modules/hosts/<novo-host>/ e:
  #   1. troque "template" pelo nome do host aqui embaixo
  #      (den.hosts.x86_64-linux.<novo-host> e den.aspects.<novo-host>),
  #      incluindo isGaming/isLaptop
  #   2. rode `nixos-generate-config` na máquina alvo e copie o
  #      hardware-configuration.nix gerado pra ./_hardware.nix
  #   3. ajuste a lista de includes pro que esse host realmente precisa
  #      (kde/flatpak são opcionais; gaming/laptop já resolvem sozinhos
  #      a partir de host.isGaming/isLaptop via `identities`; niri/xdg/
  #      noctalia vêm via `wm`, incluído do lado do user, não do host)

  den.hosts.x86_64-linux.template = {
    hostName = "template";
    kernel = "latest";
    isLaptop = false;
    users.flp = { };
  };

  den.aspects.template = {
    includes = with den.aspects; [
      den.provides.hostname

      essential
      security
      grub
      # kde
      cli
      fish
      # flatpak
      cachy-kernel
      # latest-kernel

      identities

      { nixos = import ./_hardware.nix; }
    ];

  };
}
