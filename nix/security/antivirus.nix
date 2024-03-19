{
  pkgs,
  lib,
  systemConfig,
  ...
}: {
  environment.systemPackages = [
    pkgs.clamav
    (lib.mkIf (!systemConfig.headless) pkgs.clamtk)
  ];
}
