{ inputs, lib, ... }: {
  den.aspects.mango.homeManager =
    { pkgs, ... }:
    let
      mangoPackage = inputs.mango.packages.${pkgs.stdenv.hostPlatform.system}.mango;
      bindingPrefixes = [
        "bind="
        "bindl="
        "mousebind="
        "axisbind="
        "gesturebind="
        "switchbind="
        "keymode="
      ];
      isBinding = line: lib.any (prefix: lib.hasPrefix prefix line) bindingPrefixes;
      defaultConfigWithoutBindings = lib.concatStringsSep "\n" (
        lib.filter (line: !isBinding line) (
          lib.splitString "\n" (builtins.readFile "${inputs.mango}/assets/config.conf")
        )
      );
    in
    {
      imports = [ inputs.mango.hmModules.mango ];

      wayland.windowManager.mango = {
        enable = true;
        package = mangoPackage;
        settings = {
          bind = [ ];
          bindl = [ ];
          mousebind = [ ];
          axisbind = [ ];
          gesturebind = [ ];
          switchbind = [ ];
          keymode = { };
        };
        extraConfig = defaultConfigWithoutBindings;
      };
    };
}
