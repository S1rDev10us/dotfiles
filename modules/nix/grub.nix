{
  lib,
  opts,
  ...
}:
lib.mkIf (opts.grub.enable) {
  assertions = [
    {
      assertion = opts.grub.efiLocation != "" || !opts.grub.useEfi;
      message = "If using efi mode for grub, efiLocation MUST be set";
    }
  ];
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
        version = 2;
        extraEntries = ''
          menuentry "Windows" {
            insmod part_gpt
            insmod fat
            insmod search_fs_uuid
            insmod chain
            search --fs-uuid --set=root ${opts.grub.efiLocation}
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
    };
}
