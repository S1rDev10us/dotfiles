{config, ...}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-51ab5daa-82a9-449c-b83f-ab7c8014c0a4".device = "/dev/disk/by-uuid/51ab5daa-82a9-449c-b83f-ab7c8014c0a4";

  # NVIDIA graphics
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = true; # see the note above
  unfreePackages = [config.boot.kernelPackages.nvidia_x11 "nvidia-settings"];
  # Required for Wayland?
  hardware.nvidia.modesetting.enable = true;
}
