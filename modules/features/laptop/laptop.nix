{ den, ... }: {
  den.aspects.laptop = {
    includes = with den.aspects; [
      auto-cpufreq
      bluetooth
      wifi
    ];

    nixos = {
      services.logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "lock";
      };
    };
  };
}
