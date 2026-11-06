{ den, ... }: {
  # Bundle de apps pra hosts "não leves" (CPU/RAM de sobra) — hosts leves
  # (ex. aspire) simplesmente não incluem isto.
  den.aspects.desktop-apps = {
    includes = with den.aspects; [
      gaming-stack

      zen-browser

      discord
      spotify
      zapzap
      obsidian
      gimp

      git

      # arduino
      # rstudio
    ];
  };
}
