{
  den.aspects.fish = {
    homeManager = { pkgs, ... }: {
      programs.fish = {
        plugins =
          map
            (name: {
              inherit name;
              inherit (pkgs.fishPlugins.${name}) src;
            })
            [
              "autopair"
              "fzf-fish"
              "done"
              "sponge"
            ];

        interactiveShellInit = ''
          set -g __done_min_cmd_duration 10000
          set -g __done_notification_urgency_level low

          set -g fzf_preview_dir_cmd eza --all --color=always --icons=always --group-directories-first
          set -g fzf_fd_opts --hidden --exclude=.git
        '';
      };

      # O done notifica pelo notify-send.
      home.packages = [ pkgs.libnotify ];
    };
  };
}
