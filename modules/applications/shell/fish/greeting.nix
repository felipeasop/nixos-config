{
  den.aspects.fish = {
    homeManager =
      { config, ... }:
      let
        c = config.lib.stylix.colors;
      in
      {
        # Cada item é cor, ícone e valor; só o primeiro shell mostra (não subshells).
        programs.fish.functions.fish_greeting = ''
          test "$SHLVL" -gt 1 2>/dev/null; and return

          set -l seconds (string split -f1 . < /proc/uptime)
          set -l days (math -s0 "$seconds / 86400")
          set -l hours (math -s0 "$seconds % 86400 / 3600")
          set -l mins (math -s0 "$seconds % 3600 / 60")
          set -l up "$mins"m
          if test $days -gt 0
              set up "$days"d" $hours"h
          else if test $hours -gt 0
              set up "$hours"h" $mins"m
          end

          set -l items \
              ${c.base09}  $USER \
              ${c.base0A}  (prompt_hostname) \
              ${c.base0D}  (date +%H:%M) \
              ${c.base0B}  $up \
              ${c.base0C}  (string replace -rf '^PRETTY_NAME="?([^"]*)"?$' '$1' < /etc/os-release)
          set -l gen (string match -rg 'system-(\d+)-link' (readlink /nix/var/nix/profiles/system 2>/dev/null))
          and set -a items ${c.base0F}  "gen $gen"
          set -a items ${c.base0E}  (uname -r | string split -f1 -)

          set_color ${c.base0D}
          echo -n \U000F023A"  "
          for i in (seq 1 3 (count $items))
              if test $i -gt 1
                  set_color ${c.base03}
                  echo -n "  ·  "
              end
              set_color $items[$i]
              echo -n $items[(math $i + 1)]" "
              set_color ${c.base05}
              echo -n $items[(math $i + 2)]
          end
          set_color normal
          echo
        '';
      };
  };
}
