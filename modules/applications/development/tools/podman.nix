{
  den.aspects.podman = {
    nixos = { pkgs, ... }: {
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
      };

      environment.systemPackages = [ pkgs.podman-compose ];
    };
  };
}
