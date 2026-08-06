# Equivalente declarativo aos tweaks de sysctl que o LinuxToys aplica
# via scripts imperativos (CachyOS systemd/sysctl tweaks). O kernel
# linux-cachyos já tem bons defaults, mas esses dois ajustes valem a
# pena reforçar explicitamente independente do kernel escolhido.
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
