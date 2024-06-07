{
  defaultStateVersion,
  host,
  inputs,
  lib,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = lib.mkForce host;
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  time.timeZone = "Europe/London";
  services.xserver.
    layout = "uk,us";

  # Make this slightly higher priority than whatever the default is but pretty much always overrideable
  system.stateVersion = lib.mkOverride 1499 defaultStateVersion;
}
