{ den, ... }: {
  # Apps pesados; o aspire não inclui este aspect.
  den.aspects.desktop-apps = {
    includes = with den.aspects; [
      gaming-stack

      # Misc
      discord
      spotify
      zapzap
      obsidian
      gimp

      podman

      # Estudos
      orange
      pgadmin
    ];
  };
}
