{
  inputs,
  lib,
  ...
}: {
  imports = ["${inputs.nixpkgs}/nixos/modules/installer/virtualbox-demo.nix"];
  nix.settings.trusted-users = ["demo"];

  services = {
    xserver = {
      desktopManager.plasma5.enable = lib.mkForce true;
    };
    displayManager.sddm.enable = lib.mkForce true;
  };
}
