{
  stateVersion,
  host,
  inputs,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [home-manager just];
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  time.timeZone = "Europe/London";
  services.xserver.layout = "gb,us";
  services.xserver.xkb.layout = "gb,us";
  console.keyMap = "uk";

  # Make this slightly higher priority than whatever the default is but pretty much always overridable
  system.stateVersion = lib.mkForce stateVersion;
  networking.hostName = lib.mkOverride 1499 host;
}
