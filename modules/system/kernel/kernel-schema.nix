{ den, lib, ... }:
let
  kernels = with den.aspects; {
    cachy = cachy-kernel;
    latest = latest-kernel;
  };
in
{
  den = {
    schema.host.options.kernel = lib.mkOption {
      type = lib.types.enum (lib.attrNames kernels);
      description = "Kernel do host: CachyOS ou o upstream mais recente.";
    };

    aspects.kernel = { host, ... }: {
      includes = [ kernels.${host.kernel} ];
    };
  };
}
