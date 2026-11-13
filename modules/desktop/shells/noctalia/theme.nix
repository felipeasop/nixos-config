{
  den.aspects.noctalia = {
    homeManager = {
      stylix.targets.noctalia = {
        enable = true;
        # As opacidades ficam por componente em ui/*.nix.
        opacity.enable = false;
      };

      programs.noctalia.settings.theme = {
        pure_black_dark = false;

        # O Stylix define a paleta; os templates cobrem só apps que ele não tema.
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = true;
          community_ids = [ "prismlauncher" ];
        };
      };
    };
  };
}
