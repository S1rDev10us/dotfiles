# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS
  boot.initrd.luks.devices."luks-1c4c6f99-18de-49eb-a816-5361ec8ff0b0".device = "/dev/disk/by-uuid/1c4c6f99-18de-49eb-a816-5361ec8ff0b0";

  # NVIDIA graphics
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = true; # see the note above
  unfreePackages = [config.boot.kernelPackages.nvidia_x11 "nvidia-settings"];
}
