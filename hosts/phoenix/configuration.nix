{
  lib,
  pkgs,
  config,
  ...
}: {
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-51ab5daa-82a9-449c-b83f-ab7c8014c0a4".device = "/dev/disk/by-uuid/51ab5daa-82a9-449c-b83f-ab7c8014c0a4";

  # NVIDIA graphics
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = true; # see the note above
  unfreePackages = [
    config.boot.kernelPackages.nvidia_x11
    "nvidia-settings"
    # CUDA support (below)
    (pkg: pkg ? "meta" && pkg.meta ? "license" && lib.lists.all (license: license.shortName == "CUDA EULA") (lib.lists.toList pkg.meta.license))
    "cudnn"
  ];
  # Required for Wayland?
  hardware.nvidia.modesetting.enable = true;
  # CUDA support
  # WARN: without a cache this will build every package with CUDA support
  #       since Hydra (the nix ci, not the host) doesn't build CUDA packages
  nixpkgs.config.cudaSupport = true;
  nix.settings = {
    substituters = ["https://cache.nixos-cuda.org"];
    trusted-public-keys = ["cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="];
  };

  # Stream Deck
  programs.streamcontroller.enable = true;

  # alt display manager. SDDM may be causing me issues
  # :WARN: keyboard layout is US on first load atm.
  services.displayManager = {
    sddm.enable = lib.mkForce false;
    ly = {
      enable = true;
      settings = {
        clear_password = true;
        # Animation
        animate = true;
        animation = "colormix";
        colormix_col1 = "0x00B85700";
        colormix_col2 = "0x00005DB8";
        colormix_col3 = "0x0000B89C";
        # UI
        bigclock = "en";
        show_tty = true;
        # Disable X11
        xinitrc = null;
        xsessions = null;
      };
    };
  };

  # Phoenix is on Ethernet, disable
  services.borgbackup.jobs.backupToArchimedes.preHook = lib.mkBefore ''
    disable_network_check=1
  '';

  environment.systemPackages = lib.flatten [
    (let
      apps-to-run = [
        "firefox"
        "thunderbird"
        "discord"
        "obsidian"
        "super-productivity"
      ];
      open-preset-apps = pkgs.writeShellScriptBin "open-preset-apps" (
        lib.join "\n" (lib.map (app: "niri msg action spawn -- ${app}") apps-to-run)
      );
    in [
      open-preset-apps
      (pkgs.makeDesktopItem {
        name = "open-preset-apps-desktop";
        desktopName = "Open preset apps (run once on most startups)";
        exec = lib.getExe open-preset-apps;
      })
    ])
  ];
}
