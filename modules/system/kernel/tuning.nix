# Valores vm.*, watchdogs, ntsync, THP e limites de writeback do CachyOS-Settings
# (pensados para swap em zram); BBR com fq como no script bbr do LinuxToys,
# sem os buffers de 128 MB.
{
  den.aspects.kernel-tuning = {
    nixos = {
      boot = {
        # ntsync: Wine/Proton usam /dev/ntsync em vez de esync/fsync.
        kernelModules = [
          "tcp_bbr"
          "ntsync"
        ];
        blacklistedKernelModules = [
          "iTCO_wdt"
          "sp5100_tco"
        ];

        kernel.sysctl = {
          "vm.swappiness" = 100;
          "vm.vfs_cache_pressure" = 50;
          "vm.dirty_ratio" = 10;
          "vm.dirty_background_ratio" = 3;
          "vm.page-cluster" = 0;

          "kernel.nmi_watchdog" = 0;

          "net.core.default_qdisc" = "fq";
          "net.ipv4.tcp_congestion_control" = "bbr";
        };
      };

      systemd.tmpfiles.rules = [
        "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
        "w! /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none - - - - 409"
      ];

      # Pendrive, cartão e HD não acumulam GBs sujos que travam o sync ao desmontar.
      services.udev.extraRules = ''
        ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ATTR{removable}=="1", ATTR{bdi/strict_limit}="1", ATTR{bdi/max_bytes}="268435456"
        ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{bdi/strict_limit}="1", ATTR{bdi/max_bytes}="268435456"
        ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", KERNEL=="mmcblk[0-9]*", ATTR{bdi/strict_limit}="1", ATTR{bdi/max_bytes}="268435456"
        ACTION=="add|change", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ENV{ID_BUS}=="usb", ATTR{bdi/strict_limit}="1", ATTR{bdi/max_bytes}="16777216"
      '';
    };
  };
}
