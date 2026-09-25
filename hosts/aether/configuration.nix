{
  imports = [
    ./legion.nix
    ./nvidia.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-cfedbf25-b3f8-46c8-976a-be24f0b890e0".device = "/dev/disk/by-uuid/cfedbf25-b3f8-46c8-976a-be24f0b890e0";
}
