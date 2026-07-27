{
  den.aspects.auto-cpufreq = {
    nixos = {
      services.auto-cpufreq.enable = true;
      services.auto-cpufreq.settings = {
        battery.governor = "powersave";
        charger.governor = "performance";
      };

      services.power-profiles-daemon.enable = false;
      services.upower.enable = true;
    };
  };
}
