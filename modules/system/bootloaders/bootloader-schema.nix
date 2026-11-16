{ den, lib, ... }:
let
  bootloaders = with den.aspects; {
    inherit grub systemd-boot;
  };
in
{
  den = {
    schema.host.options.bootloader = lib.mkOption {
      type = lib.types.enum (lib.attrNames bootloaders);
      description = "Bootloader do host: GRUB (BIOS) ou systemd-boot (UEFI).";
    };

    aspects.bootloader = { host, ... }: {
      includes = [ bootloaders.${host.bootloader} ];
    };
  };
}
