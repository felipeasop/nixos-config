_: {
  den.schema.host.imports = [
    ({ lib, ... }: {
      options = {
        isLaptop = lib.mkOption {
          type = lib.types.bool;
          description = "Se este host deve incluir o identity de laptop (auto-cpufreq, bluetooth, wifi, lid switch).";
        };
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
