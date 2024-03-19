{
  systemConfig,
  lib,
  ...
}: {
  imports =
    [
      ./hardware/default.nix
      ./security/default.nix

      ./software/default.nix
    ]
    ++ (lib.lists.optional
      (!systemConfig.headless)
      (./desktop-environment/. + "/${systemConfig.desktop-environment}.nix"));
}
