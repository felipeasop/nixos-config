{ den, ... }: {
  den.hosts.x86_64-linux.template = {
    hostName = "template";
    kernel = "latest";
  };
  den.aspects.template = {
    includes = with den.aspects; [
      den.provides.hostname
      grub
      # kde
      cli
      fish
      # { nixos = import ./_hardware.nix; }
    ];
  };
}
