{
  opts,
  lib,
  ...
}: {
  boot.loader =
    if (! opts.grub.useEfi)
    then {
      grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
      };
    }
    else {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        devices = ["nodev"];
        efiSupport = true;
        enable = true;
        extraEntries = lib.mkIf (opts.grub.windowsLocation != "") ''
          menuentry "Windows" {
            insmod part_gpt
            insmod fat
            insmod search_fs_uuid
            insmod chain
            search --fs-uuid --set=root ${opts.grub.windowsLocation}
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
    };
}
