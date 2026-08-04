{
  den.aspects.fish = {
    homeManager = {
      programs.fish = {
        shellInit = ''
          set -g fish_greeting ""
        '';

        interactiveShellInit = ''
          function fish_greeting
              # uptime -p não existe no util-linux do NixOS (só no
              # procps/Debian) — por isso o erro "uptime: opção
              # inválida -- p". Calcula direto de /proc/uptime, sem
              # depender de flag de binário.
              set -l seconds (string split -f1 "." (cat /proc/uptime))
              set -l days (math -s0 "$seconds / 86400")
              set -l hours (math -s0 "($seconds % 86400) / 3600")
              set -l mins (math -s0 "($seconds % 3600) / 60")
              set -l up ""
              if test $days -gt 0
                  set up "$days"d" $hours"h
              else if test $hours -gt 0
                  set up "$hours"h" $mins"m
              else
                  set up "$mins"m
              end

              set -l os (grep -m1 '^ID=' /etc/os-release | cut -d= -f2 | string trim -c '"')
              set -l kernel (uname -r | cut -d- -f1)
              set -l now (date "+%H:%M")

              set_color brblue
              echo -n "  "
              set_color yellow
              echo -n "$now"
              set_color brblack
              echo -n "  "
              set_color green
              echo -n " "
              set_color brgreen
              echo -n "$up"
              set_color brblack
              echo -n "  "
              set_color cyan
              echo -n " "
              set_color brcyan
              echo -n "$os"
              set_color brblack
              echo -n "  "
              set_color purple
              echo -n " "
              set_color brpurple
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
