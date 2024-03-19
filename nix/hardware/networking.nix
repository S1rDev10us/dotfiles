{systemConfig, ...}: {
  networking = {
    networkmanager.enable = true;
    hostName = systemConfig.hostname;
  };
}
