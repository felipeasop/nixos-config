# Placeholder — substitua pelo hardware-configuration.nix real gerado por
# `nixos-generate-config` na máquina de destino antes de usar este host.
{ lib, ... }: {
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-uuid/CHANGEME";
    fsType = "ext4";
  };
}
