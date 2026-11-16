{
  den.aspects.intel-graphics = {
    nixos = { pkgs, ... }: {
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver # Broadwell em diante (iHD)
          intel-vaapi-driver # até Coffee Lake (i965)
          libvdpau-va-gl
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
