{ den, ... }: {
  den = {
    schema.host.imports = [
      ({ lib, ... }: {
        options.kernel = lib.mkOption {
          type = lib.types.enum [
            "cachy"
            "latest"
          ];
          description = "Qual kernel usar: 'cachy' (CachyOS) ou 'latest' (upstream mais recente).";
        };
      })
    ];

    aspects.kernel = { host, ... }: with den.aspects;
      {
        includes = if host.kernel == "cachy" then [ cachy-kernel ] else [ latest-kernel ];
      };
  };
}
