{
  inputs,
  pkgs,
  lib,
  ...
}: {
  # FastFetch reports my host as `UX363EA_UX371EA` so I think this is correct, it should be close enough anyway I think
  imports = [inputs.nixos-hardware.nixosModules.asus-zenbook-ux371];
  services.avahi.enable = true;

  boot.kernel.sysctl = {
    "vm.swappiness" = 20;
  };

  # nixos-hardware options
  hardware.asus.battery.chargeUpto = 80;

  services.blueman.enable = lib.mkForce false;
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
