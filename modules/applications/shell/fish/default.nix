{
  den.aspects.fish = {
    nixos = {
      programs.fish.enable = true;
    };

    homeManager = { pkgs, ... }: {
      programs.fish.enable = true;
      home.packages = with pkgs; [
        eza
        bat
        hwinfo
        netcat
        fzf
      ];
    };
  };
}
