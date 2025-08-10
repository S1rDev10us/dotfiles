{
  stateVersion,
  host,
  inputs,
  lib,
  pkgs,
  opts,
  ...
}: {
  services.xserver.excludePackages = with pkgs; [xterm];

  networking.networkmanager.enable = true;

  security.polkit = lib.mkIf opts.GUI {enable = true;};
  hardware.graphics.enable = lib.mkForce opts.GUI;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Packages required to run flakes (not to edit them)
  environment.systemPackages = with pkgs; [home-manager];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  nixpkgs.flake.source = lib.mkForce inputs.nixpkgs;

  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n = rec {
    defaultLocale = "en_GB.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };
  };

  # These shouldn't be overridden from config files, it should be set from the other modules system.
  # Hostname is slightly higher priority because there might be *some* reasons you want to override it but you probably shouldn't
  system.stateVersion = lib.mkForce stateVersion;
  # Make it very slightly above the normal value so you do have to use mkForce
  networking.hostName = lib.mkOverride 99 host;

  # Automatic garbage collection and optimisation
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;
}
