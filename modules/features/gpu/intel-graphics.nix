{
  den.aspects.intel-graphics = {
    nixos = { pkgs, ... }: {
      hardware.graphics = {
        enable = true;
        extraPackages = [
          pkgs.intel-vaapi-driver
          pkgs.libvdpau-va-gl
        ];
      };
    };

    provides.to-users = {
      homeManager = {
        programs.firefox.profiles.default.settings = {
          "media.ffmpeg.vaapi.enabled" = true;
          "media.hardware-video-decoding.force-enabled" = true;
        };
      };
    };
  };
}
