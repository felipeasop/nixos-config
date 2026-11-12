{
  den.aspects.fish = {
    homeManager = {
      programs.fish.shellAliases = {
        ls = "eza --group-directories-first --icons=auto";
        la = "eza -a --group-directories-first --icons=auto";
        ll = "eza -l --group-directories-first --icons=auto";
        lt = "eza -aT --group-directories-first --icons=auto";
        "l." = "eza -a | grep -e '^\\.'";
        tree = "eza --tree --group-directories-first --icons=auto";
        cat = "bat --plain --paging=never";

        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";

        tarnow = "tar -acf ";
        untar = "tar -zxvf ";
        wget = "wget -c ";
        psmem = "ps auxf | sort -nr -k 4";
        psmem10 = "ps auxf | sort -nr -k 4 | head -10";
        dir = "dir --color=auto";
        vdir = "vdir --color=auto";
        grep = "grep --color=auto";
        fgrep = "fgrep --color=auto";
        egrep = "egrep --color=auto";
        hw = "hwinfo --short";
        tb = "nc termbin.com 9999";
        jctl = "journalctl -p 3 -xb";

        rollback = "sudo nixos-rebuild switch --rollback";
        gens = "nix-env --list-generations --profile /nix/var/nix/profiles/system";
      };
    };
  };
}
