{
  den.aspects.fish = {
    homeManager = {
      programs.fish.interactiveShellInit = ''
        function write-flake
            cd $NIXOS_CONFIG_DIR; or return 1
            nix run .#write-flake
            and git add -A
            and git diff --cached --stat flake.nix
        end

        function __history_previous_command
          switch (commandline -t)
          case "!"
            commandline -t $history[1]; commandline -f repaint
          case "*"
            commandline -i !
          end
        end

        function __history_previous_command_arguments
          switch (commandline -t)
          case "!"
            commandline -t ""
            commandline -f history-token-search-backward
          case "*"
            commandline -i '$'
          end
        end

        if [ "$fish_key_bindings" = fish_vi_key_bindings ]
          bind -Minsert ! __history_previous_command
          bind -Minsert '$' __history_previous_command_arguments
        else
          bind ! __history_previous_command
          bind '$' __history_previous_command_arguments
        end

        function history
            builtin history --show-time='%F %T ' $argv
        end

        function backup --argument filename
            cp $filename $filename.bak
        end

        function copy
            set count (count $argv | tr -d \n)
            if test "$count" = 2; and test -d "$argv[1]"
                set from (echo $argv[1] | string trim --right --chars=/)
                set to (echo $argv[2])
                command cp -r $from $to
            else
                command cp $argv
            end
        end
      '';
    };
  };
}
