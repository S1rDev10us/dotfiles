{
  lib,
  opts,
  ...
}:
lib.mkIf (!opts.WSL.enable) {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
}
