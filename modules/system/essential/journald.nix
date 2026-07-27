{
  den.aspects.essential = {
    nixos = {
      services.journald.extraConfig = "SystemMaxUse=500M";
    };
  };
}
