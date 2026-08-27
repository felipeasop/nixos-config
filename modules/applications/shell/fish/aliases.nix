{
  den.aspects.fish = {
    homeManager = {
      programs.fish.shellAliases = {
        ls = "eza -al --color=always --group-directories-first --icons=always";
        la = "eza -a --color=always --group-directories-first --icons=always";
        ll = "eza -l --color=always --group-directories-first --icons=always";
        lt = "eza -aT --color=always --group-directories-first --icons=always";
        "l." = "eza -a | grep -e '^\\.'";

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
        gs = "git status";

        rollback = "sudo nixos-rebuild switch --rollback";
        cleanup = "sudo nix-collect-garbage -d";
        gens = "nix-env --list-generations --profile /nix/var/nix/profiles/system";
      };
    };
  };
}
