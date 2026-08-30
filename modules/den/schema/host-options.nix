_: {
  den.schema.host.imports = [
    ({ lib, ... }: {
      options = {
        kernel = lib.mkOption {
          type = lib.types.enum [
            "cachy"
            "latest"
          ];
          description = "Qual kernel usar: 'cachy' (CachyOS) ou 'latest' (upstream mais recente).";
        };
      };
    })
  ];
}
