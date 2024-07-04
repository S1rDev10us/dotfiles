{
  stateVersion,
  host,
  inputs,
  lib,
  pkgs,
  ...
}: {
  # Packages required to run flakes (not to edit them)
  environment.systemPackages = with pkgs; [home-manager just];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  time.timeZone = "Europe/London";

  # services.xserver.layout = "gb,us";
  services.xserver.xkb.layout = "gb,us";
  console.keyMap = "uk";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  # These shouldn't be overridden from config files, it should be set from the other modules system.
  # Hostname is slightly higher priority because there might be *some* reasons you want to override it but you probably shouldn't
  system.stateVersion = lib.mkForce stateVersion;
  # Make it very slightly above the normal value so you do have to use mkForce
  networking.hostName = lib.mkOverride 99 host;
}
