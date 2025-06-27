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
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.8") pkgs.linuxPackages_6_12;
  services.avahi.enable = true;

  environment.systemPackages = with pkgs; [
    # Calculator
    kdePackages.kalgebra
    rink
  ];

  # nixos-hardware options
  hardware.asus.battery.chargeUpto = 80;
}
