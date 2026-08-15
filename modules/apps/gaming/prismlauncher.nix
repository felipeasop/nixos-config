{
  den.aspects.prismlauncher = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.prismlauncher ];
    };
  };
}
