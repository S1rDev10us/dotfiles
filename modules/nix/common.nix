{
  host,
  stateVersion,
  inputs,
  lib,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = lib.mkForce host;
  system.stateVersion = stateVersion;
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
}
