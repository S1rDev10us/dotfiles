{...}: {
  boot = {
    loader.grub = {
      device = "/dev/sda";
      useOSProber = true;
      enable = true;
    };

    plymouth.enable = true;
    kernelParams = [
      "splash"
      "quiet"
      "loglevel=3"
    ];
  };
}
