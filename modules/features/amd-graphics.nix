{
  den.aspects.amd-graphics = {
    nixos = { pkgs, ... }: {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [ libva ];
      };

      environment.sessionVariables = {
        MESA_SHADER_CACHE_MAX_SIZE = "8G";
      };
    };
  };
}
