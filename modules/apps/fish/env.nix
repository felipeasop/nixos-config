{
  den.aspects.fish = {
    homeManager = {
      programs.fish.interactiveShellInit = ''
        if test -f ~/.fish_profile
          source ~/.fish_profile
        end

        fish_add_path ~/.local/bin ~/.cargo/bin ~/Applications/depot_tools
      '';
    };
  };
}
