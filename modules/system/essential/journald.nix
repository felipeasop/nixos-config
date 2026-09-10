{
  den.aspects.essential = {
    nixos = {
      services.journald.settings.Journal.SystemMaxUse = "500M";
    };
  };
}
