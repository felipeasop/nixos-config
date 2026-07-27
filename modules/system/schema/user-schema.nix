{ lib, ... }: {
  den.schema.user.imports = [
    ({ lib, ... }: {
      options = {
        isGaming = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Se este usuário deve incluir o identity de gaming (steam,
            proton, gamescope, etc).
          '';
        };

        fullName = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Nome completo do usuário, usado como `description` da
            conta do sistema (aparece em telas de login, `finger`,
            etc). Opcional — se null, o campo fica vazio.
          '';
        };

        email = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            E-mail do usuário. Não é consumido automaticamente por
            nenhuma battery hoje, mas fica disponível no contexto
            `user` para aspects que queiram usá-lo (ex: git user.email,
            gpg key lookup, etc).
          '';
        };
      };
    })
  ];
}
