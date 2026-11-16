{
  den.aspects.fish = {
    homeManager = {
      programs.fish.functions = {
        history = ''
          if contains -- "$argv[1]" delete merge clear clear-session save append
              builtin history $argv
          else
              builtin history --show-time='%F %T ' $argv
          end
        '';

        # backup arq [arq...] → arq.bak; pergunta antes de sobrescrever.
        backup = ''
          for f in $argv
              cp -ai -- $f $f.bak
          end
        '';
      };
    };
  };
}
