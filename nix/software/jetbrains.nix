{
  systemConfig,
  lib,
  pkgs,
  ...
}:
lib.mkIf (!systemConfig.headless) {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages =
    (with pkgs; [
      jetbrains-toolbox
    ])
    ++ (with pkgs.jetbrains; [
      rider
    ]);
}
