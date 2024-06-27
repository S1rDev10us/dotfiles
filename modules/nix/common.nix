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
  # services.xserver.layout = "gb,us";
  services.xserver.xkb.layout = "gb,us";
  console.keyMap = "uk";

  # These shouldn't be overridden from config files, it should be set from the other modules system.
  # Hostname is slightly higher priority because there might be *some* reasons you want to override it but you probably shouldn't
  system.stateVersion = lib.mkForce stateVersion;
  # Make it very slightly above the normal value so you do have to use mkForce
  networking.hostName = lib.mkOverride 99 host;
}
