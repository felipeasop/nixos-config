{ den, ... }: {
  den = {
    hosts.x86_64-linux.template = {
      hostName = "template";
      kernel = "latest";
    };
    aspects.template = {
      includes = with den.aspects; [
        den.batteries.hostname
        grub
        # kde
        cli
        fish
        # { nixos = import ./_hardware.nix; }
      ];
    };
  };
}
