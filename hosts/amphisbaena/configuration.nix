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
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.8") pkgs.linuxPackages_6_11;
  services.avahi.enable = true;
  services.desktopManager.plasma6.enable = lib.mkForce false;
  specialisation.plasma.configuration = {
    services.desktopManager.plasma6.enable = lib.mkOverride 49 true;
    programs.hyprland.enable = lib.mkForce false;
    services.displayManager.defaultSession = lib.mkOverride 49 "plasma";
  };
}
