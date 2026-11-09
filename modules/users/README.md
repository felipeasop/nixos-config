# users

Um arquivo por usuário: identidade, shell de login e permissões
(`user-shell`, `primary-user`), apps e preferências além do baseline. O
mesmo aspect vale em host NixOS e em home standalone; o que o host empurra
(`provides.to-users`, `host-aspects`) só chega ao usuário dentro do host.

- `flp.nix`: também declara o home standalone `flp`, para Nix fora do NixOS
  (`home-manager switch --flake .#flp`). Em host NixOS o `flp` já vem
  integrado; não ative os dois na mesma máquina.
