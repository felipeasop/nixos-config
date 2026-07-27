{ den, ... }: {
  den.aspects.ssh-identity-for =
    { user }:
    {
      nixos =
        { config, ... }:
        {
          sops.secrets."ssh/${config.networking.hostName}/private_key" = {
            path = "/home/${user}/.ssh/id_ed25519";
            owner = user;
            mode = "0600";
          };

          sops.secrets."ssh/${config.networking.hostName}/public_key" = {
            path = "/home/${user}/.ssh/id_ed25519.pub";
            owner = user;
            mode = "0644";
          };
        };
    };
}
