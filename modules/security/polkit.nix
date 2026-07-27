# O KDE já sobe seu próprio agente (plasma-polkit-agent) sozinho junto do plasma6.nix
# Necessário para niri que não possui agente de polkit embutido
# Sem isso a sessão niri fica sem diálogo de autenticação gráfico.
{
  den.aspects.security = {
    nixos = {
      security.polkit.enable = true;
    };
  };
}
