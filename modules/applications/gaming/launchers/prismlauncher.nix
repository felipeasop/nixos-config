{
  den.aspects.prismlauncher = {
    homeManager = { pkgs, ... }: {
      programs.prismlauncher = {
        enable = true;
        package = pkgs.prismlauncher.override {
          jdks = with pkgs; [
            jdk21
            jdk25
          ];
        };
      };
    };
  };
}
