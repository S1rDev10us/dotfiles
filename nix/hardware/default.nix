{systemConfig, ...}: {
  imports = [
    ./audio.nix
    ./boot.nix
    ./hardware-configuration.nix
    ./keymap.nix
    ./localization.nix
    ./networking.nix
    ./printing.nix
  ];
  nixpkgs.hostPlatform = systemConfig.systemArchitecture;
}
