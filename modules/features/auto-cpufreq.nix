{
  den.aspects.auto-cpufreq = {
    nixos = {
      services = {
        auto-cpufreq = {
          enable = true;
          settings = {
            battery.governor = "powersave";
            charger.governor = "performance";
          };
        };
        power-profiles-daemon.enable = false;
        upower.enable = true;
      };
    };
  };
}
