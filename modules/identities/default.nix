{ lib, den, ... }: {
  den.aspects.identities = { host, user }: with den.aspects; {
      includes =
        lib.optionals (user.isGaming or false) [ gaming ]
        ++ lib.optionals (host.isLaptop or false) [ laptop ];
    };
}
