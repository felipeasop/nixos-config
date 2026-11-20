# Os mesmos slices que o Fedora vigia; no NixOS o systemd-oomd roda sem nenhum.
{
  den.aspects.essential = {
    nixos = {
      systemd = {
        oomd = {
          enableRootSlice = true;
          enableUserSlices = true;
        };

        # Com o swap acima de 90%, mata o maior consumidor antes de o sistema travar.
        slices."-".sliceConfig.ManagedOOMSwap = "kill";

        # Compositor e shell (session.slice) nunca são escolhidos, como no CachyOS.
        user.slices.session = {
          overrideStrategy = "asDropin";
          sliceConfig.ManagedOOMPreference = "omit";
        };
      };
    };
  };
}
