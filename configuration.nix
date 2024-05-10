{...}: {
  imports = [./nix/default.nix];
  system.stateVersion = "23.11";
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
