{
  den.aspects.starship = {
    homeManager = {
      programs.starship = {
        enable = true;

        settings = fromTOML (builtins.readFile ./nerd-font-symbols.toml) // {
          add_newline = false;
          scan_timeout = 500;
          command_timeout = 2000;
        };
      };
    };
  };
}
