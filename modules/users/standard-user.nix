# Esqueleto de usuário reaproveitável: só a infraestrutura (define-user,
# primary-user, shell, grupos), sem nenhum app ou gosto pessoal.
#
# Para criar um novo usuário humano:
#   1. cria modules/users/<nome>.nix
#   2. includes = [ standard-user <apps que esse usuário quiser> ]
#   3. (opcional) sobrescreva user-shell se quiser outro shell além de fish
{ den, ... }: {
  den.aspects.standard-user = {
    includes =
      with den.provides;
      with den.aspects;
      [
        define-user
        primary-user
        (user-shell "fish")
      ];
  };
}
