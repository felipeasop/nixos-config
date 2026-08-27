{
  den.aspects.fish = {
    homeManager = { pkgs, ... }: {
      programs.fish.plugins = [
        {
          name = "pure";
          src = pkgs.fishPlugins.pure.src;
        }
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
        {
          name = "sponge";
          src = pkgs.fetchFromGitHub {
            owner = "meaningful-ooo";
            repo = "sponge";
            rev = "384299545104d5256648cee9d8b117aaa9a6d7be";
            sha256 = "sha256-MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
          };
        }
      ];
    };
  };
}
