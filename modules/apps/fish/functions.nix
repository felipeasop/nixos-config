{
  den.aspects.fish = {
    homeManager = {
      programs.fish.interactiveShellInit = ''
        # Fluxo único de rebuild, combinável por subcomando:
        #   rebuild                -> git add -A + nh os switch . -v
        #   rebuild update         -> + atualiza flake.lock (nh --update)
        #   rebuild flake          -> + regenera flake.nix (write-flake) antes
        #   rebuild flake update   -> os dois juntos
        #   rebuild test [...]     -> nh os test em vez de switch (não persiste no boot)
        # Qualquer argumento extra não reconhecido é repassado pro nh (ex: rebuild -H outname).
        function rebuild
            cd $NIXOS_CONFIG_DIR; or return 1

            set -l cmd switch
            set -l do_flake 0
            set -l do_update 0
            set -l passthrough

            for arg in $argv
                switch $arg
                    case flake
                        set do_flake 1
                    case update
                        set do_update 1
                    case test
                        set cmd test
                    case '*'
                        set -a passthrough $arg
                end
            end

            if test $do_flake -eq 1
                nix run .#write-flake; or return 1
            end

            git add -A

            set -l nh_args -v
            if test $do_update -eq 1
                set -a nh_args --update
            end

            nh os $cmd . $nh_args $passthrough
        end

        # Só regenera o flake.nix a partir dos flake-file.inputs
        # distribuídos pelos módulos, sem rebuildar nada. Útil pra
        # revisar o diff antes de aplicar (equivale a `rebuild flake`
        # sem o rebuild em si).
        function flake-regenerate
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
