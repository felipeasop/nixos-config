{ den, ... }: {
  den.aspects.multimedia = {
    includes = with den.aspects; [
      ffmpeg
      vlc
    ];
  };
}
