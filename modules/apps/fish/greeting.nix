{
  den.aspects.fish = {
    homeManager = {
      programs.fish = {
        shellInit = ''
          set -g fish_greeting ""
        '';

        interactiveShellInit = ''
          function fish_greeting
              set_color yellow
              echo -n "time "
              set_color bryellow
              set -l now (date "+%H:%M")
              echo -n "$now"
              set_color brblack
              echo -n " || "
              set_color green;
              echo -n "up "
              set_color brgreen
              set -l up (uptime -p | string replace "up " "" \
                                  | string replace " hours, " "h " \
                                  | string replace " hour, " "h " \
                                  | string replace " hours" "h" \
                                  | string replace " hour" "h" \
                                  | string replace " minutes" "m" \
                                  | string replace " minute" "m")
              echo -n "$up"
              set_color brblack
              echo -n " || "
              set_color cyan;
              echo -n "os "
              set_color brcyan
              set -l os (grep -m1 '^ID=' /etc/os-release | cut -d= -f2 | string trim -c '"')
              echo -n "$os"
              set_color brblack
              echo -n " || "
              set_color purple;
              echo -n "kernel "
              set_color brpurple
              set -l kernel (uname -r | cut -d- -f1)
              echo -n "$kernel"
              set_color normal
              echo
          end

          set -x MANROFFOPT "-c"
          if command -v bat >/dev/null 2>&1
              set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
          end

          set -U __done_min_cmd_duration 10000
          set -U __done_notification_urgency_level low
        '';
      };
    };
  };
}
