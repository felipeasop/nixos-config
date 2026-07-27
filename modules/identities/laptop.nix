{ den, ... }: {
  den.aspects.laptop = {
    includes = with den.aspects; [
      auto-cpufreq
      bluetooth
      wifi
    ];

    nixos = {
      services.logind.lidSwitch = "suspend";
      services.logind.lidSwitchExternalPower = "lock";
    };
  };
}
