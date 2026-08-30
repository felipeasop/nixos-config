## Flatpak

O aspect `flatpak` é infraestrutura de sistema e fica separado de `essential`,
embora seja incluído globalmente em `den.schema.host.includes`. Assim ele pode
ser removido ou condicionado sem alterar o baseline essencial, enquanto os
aspects de aplicações declaram pacotes em `services.flatpak.packages`.
