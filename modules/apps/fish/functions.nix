{
  den.aspects.fish = {
    homeManager = {
      programs.fish.interactiveShellInit = ''
        if test -f ~/.fish_profile
          source ~/.fish_profile
        end

        fish_add_path ~/.local/bin ~/.cargo/bin ~/Applications/depot_tools

        # Fluxo do dia a dia: stage tudo + rebuild via nh (progress bar,
        # diff bonito). Use pra qualquer mudança que NÃO adicione/altere
        # um flake-file.inputs em algum módulo.
        function rebuild
            cd $NIXOS_CONFIG_DIR; or return 1
            git add -A
            nh os switch . $argv
        end

        function rebuild-test
            cd $NIXOS_CONFIG_DIR; or return 1
            git add -A
            nh os test . $argv
        end

        # Atualiza o flake.lock (todas as dependências) e rebuilda.
        function rebuild-update
            cd $NIXOS_CONFIG_DIR; or return 1
            nh os switch . --update $argv
        end

        # Só regenera o flake.nix a partir dos flake-file.inputs
        # distribuídos pelos módulos, sem rebuildar nada. Útil pra
        # revisar o diff antes de aplicar.
        function flake-regenerate
            cd $NIXOS_CONFIG_DIR; or return 1
            nix run .#write-flake
            and git add -A
            and git diff --cached --stat flake.nix
        end

        # Fluxo completo: regenera flake.nix (pega inputs novos/mudados),
        # stage tudo, rebuild via nh. Use quando você sabe que mexeu em
        # flake-file.inputs (ex: adicionou input num módulo novo).
        function rebuild-with-new-inputs
            cd $NIXOS_CONFIG_DIR; or return 1
            nix run .#write-flake
            and git add -A
            and nh os switch . $argv
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
