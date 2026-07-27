{
  den.aspects.essential = {
    nixos = {
      services.fail2ban = {
        enable = true;
        maxretry = 5;
        bantime = "1h";
      };
    };
  };
}
