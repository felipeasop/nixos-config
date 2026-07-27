{ den, ... }: {
  den.aspects.kernel = { host, ... }: with den.aspects;
    {
      includes = if host.kernel == "cachy" then [ cachy-kernel ] else [ latest-kernel ];
    };
}
