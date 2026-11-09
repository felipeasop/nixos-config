# Equivalente declarativo aos tweaks de sysctl que o LinuxToys aplica
# via scripts imperativos (CachyOS systemd/sysctl tweaks).
{
  den.aspects.kernel-tuning = {
    nixos = {
      boot.kernel.sysctl = {
        "vm.dirty_ratio" = 10;
        "vm.dirty_background_ratio" = 5;
        "vm.swappiness" = 20;
      };
    };
  };
}
