{
  den.aspects.fish = {
    homeManager = {
      programs.fish.interactiveShellInit = ''
        if test -f ~/.fish_profile
          source ~/.fish_profile
        end

        fish_add_path ~/.local/bin ~/.cargo/bin ~/Applications/depot_tools

        # Usado pelas funções rebuild* em functions.nix pra sempre operar
        # no repo certo, independente de qual diretório você estava.
        set -gx NIXOS_CONFIG_DIR ~/nixos-config
      '';
    };
  };
}
