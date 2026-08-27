{ den, ... }: {
  den.aspects.tmux = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.tmux ];
    };
  };
}
