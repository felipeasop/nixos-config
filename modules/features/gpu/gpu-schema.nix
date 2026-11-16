{ den, lib, ... }:
let
  vendors = with den.aspects; {
    amd = amd-graphics;
    intel = intel-graphics;
    inherit nvidia;
  };
in
{
  den = {
    schema.host.options.gpus = lib.mkOption {
      type = lib.types.nonEmptyListOf (lib.types.enum (lib.attrNames vendors));
      description = "GPUs do host; um notebook híbrido lista a integrada e a dedicada.";
    };

    aspects.gpu = { host, ... }: {
      includes =
        map (vendor: vendors.${vendor}) host.gpus
        ++ lib.optional (lib.elem "nvidia" host.gpus && lib.length host.gpus > 1) den.aspects.nvidia-prime;
    };
  };
}
