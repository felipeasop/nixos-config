{ den, inputs, ... }:
let
  identity = {
    name = "felipeasop";
    email = "flpasop27@gmail.com";
  };
  avatar = "${inputs.self}/assets/avatar/margarida.jpg";
in
{
  den = {
    # Home standalone para Nix fora do NixOS; em host NixOS o flp já vem integrado.
    homes.x86_64-linux.flp = { };

    aspects.flp = {
      includes = with den.aspects; [
        den.batteries.host-aspects
        den.batteries.primary-user
        (den.batteries.user-shell "fish")

        dev

        fish
        starship
        claude-code

        yazi
      ];

      homeManager = {
        home.file.".face".source = avatar;

        programs = {
          git = {
            enable = true;
            settings.user = identity;
          };
          jujutsu.settings.user = identity;
        };
      };

      # O SDDM não lê a home do usuário; busca o avatar em AccountsService/icons/<usuário>.
      provides.to-hosts = {
        nixos = {
          systemd.tmpfiles.rules = [ "L+ /var/lib/AccountsService/icons/flp - - - - ${avatar}" ];
        };
      };
    };
  };
}
