{
  den.aspects.ffmpeg = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.ffmpeg ];
    };
  };
}
