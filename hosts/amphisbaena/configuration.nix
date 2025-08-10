{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  # FastFetch reports my host as `UX363EA_UX371EA` so I think this is correct, it should be close enough anyway I think
  imports = [inputs.nixos-hardware.nixosModules.asus-zenbook-ux371];
  # There's theoretically a fix for my speakers in a 6.7 kernel upgrade
  # boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.8") pkgs.linuxPackages_6_12;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.avahi.enable = true;

  boot.kernel.sysctl = {
    "vm.swappiness" = 40;
  };

  # nixos-hardware options
  hardware.asus.battery.chargeUpto = 80;
  services.postgresql = {
    ensureDatabases = ["s1rdev10us"];
    ensureUsers = [
      {
        name = "s1rdev10us";
        ensureDBOwnership = true;
      }
    ];
  };
}
