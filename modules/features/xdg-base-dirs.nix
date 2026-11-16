{
  den.aspects.xdg-base-dirs = {
    homeManager =
      {
        lib,
        pkgs,
        osConfig ? null,
        ...
      }:
      {
        home.preferXdgDirectories = true;

        # No NixOS vai no nix.conf do sistema: no do usuário o daemon o recusa com aviso.
        nix = lib.mkIf (osConfig == null) {
          package = pkgs.nix;
          settings.use-xdg-base-directories = true;
        };

        xdg = {
          enable = true;
          # Para o xdg-ninja: caminhos sem alternativa XDG ou que apps antigos só leem ali.
          configFile."xdg-ninja/ignore".text = ''
            .pki
            .ssh
            .themes
            .Xresources
          '';
        };
      };

    nixos = {
      nix.settings.use-xdg-base-directories = true;
    };
  };
}
