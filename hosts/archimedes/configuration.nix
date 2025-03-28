{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [inputs.nixos-hardware.nixosModules.raspberry-pi-4 ./k8s.nix];

  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.generic-extlinux-compatible.enable = true;

  environment.systemPackages = with pkgs; [
    vim
  ];
}
