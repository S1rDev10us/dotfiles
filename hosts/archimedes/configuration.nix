{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [inputs.nixos-hardware.nixosModules.raspberry-pi-4 ./k3s.nix];

  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # k3s cgroup memory issue
  # https://github.com/k3d-io/k3d/discussions/854
  # https://old.reddit.com/r/NixOS/comments/10huogm/k3s_does_not_find_memory_cgroup_v2/
  boot.kernelParams = ["cgroup_enable=memory" "cgroup_enable=cpuset" "cgroup_memory=1"];

  environment.systemPackages = with pkgs; [
    vim
  ];
}
