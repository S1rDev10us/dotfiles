{
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governer = "powersave";
        turbo = "never";
      };
      charger = {
        governer = "performance";
        turbo = "auto";
      };
    };
  };
  powerManagement.powertop.enable = true;
  services.upower.enable = true;
}
