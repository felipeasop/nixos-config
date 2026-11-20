{
  den.aspects.audio = {
    nixos = {
      security.rtkit.enable = true;
      services = {
        pulseaudio.enable = false;

        pipewire = {
          enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
          pulse.enable = true;

          # O AGC do Discord e do chat de voz do Steam baixa o volume do microfone no sistema.
          extraConfig.pipewire-pulse."90-block-agc"."pulse.rules" = [
            {
              matches = [
                { "application.process.binary" = "~[Dd]iscord"; }
                { "application.process.binary" = "~^steam(webhelper)?$"; }
              ];
              actions.quirks = [ "block-source-volume" ];
            }
          ];
        };
      };
    };
  };
}
