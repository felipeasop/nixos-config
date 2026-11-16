{
  den.aspects.fish = {
    homeManager = {
      programs.fish = {
        shellAliases = {
          ls = "eza --group-directories-first --icons=auto";
          la = "eza -a --group-directories-first --icons=auto";
          ll = "eza -l --group-directories-first --icons=auto";
          tree = "eza --tree --group-directories-first --icons=auto";
          cat = "bat --plain --paging=never";

          psmem = "ps auxf | sort -nr -k 4";
          psmem10 = "ps auxf | sort -nr -k 4 | head -10";
          grep = "grep --color=auto";
          tb = "nc termbin.com 9999";
          jctl = "journalctl -p 3 -xb";

          rollback = "sudo nixos-rebuild switch --rollback";
          gens = "nixos-rebuild list-generations";
        };
      };
    };
  };
}
