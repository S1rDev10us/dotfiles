{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.nixos-hardware.nixosModules.lenovo-legion-16iax10h];
  environment.systemPackages = with pkgs; [
    lenovo-legion
  ];
  boot.kernelModules = ["legion-laptop"];
  unfreePackages = [
    config.boot.kernelPackages.nvidia_x11
    "nvidia-settings"
    # CUDA support (below)
    (pkg: pkg ? "meta" && pkg.meta ? "license" && lib.lists.all (license: license.shortName == "CUDA EULA") (lib.lists.toList pkg.meta.license))
    "cudnn"
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-cfedbf25-b3f8-46c8-976a-be24f0b890e0".device = "/dev/disk/by-uuid/cfedbf25-b3f8-46c8-976a-be24f0b890e0";

  nixpkgs.overlays = [
    (final: prev: {
      btop = prev.btop.override {cudaSupport = true;};
    })

    # Need to use a version >= 0.0.27
    (final: prev: {
      lenovo-legion = prev.lenovo-legion.overrideAttrs (prevAttrs: {
        version = "0.0.31-unstable-2026-09-21";
        src = pkgs.fetchFromGitHub {
          owner = "johnfanv2";
          repo = "LenovoLegionLinux";
          rev = "877b826306241e0f6731cfd2c67c80ed6dc02560";
          hash = "sha256-GAPJK2+eIlpfwg8Mw13TGVCeOdVHJ40evpJbid4pD6g=";
        };
        postPatch = ''
          # only fixup application (legion-linux-gui), service (legiond) currently not installed so do not fixup
          # /etc
          substituteInPlace ./legion_linux/legion.py \
            --replace-fail "/etc/legion_linux" "$out/share/legion_linux"

          # /usr
          substituteInPlace ./legion_linux/legion_gui.desktop \
            --replace-fail "Icon=/usr/share/pixmaps/legion_logo.png" "Icon=legion_logo"
        '';
      });
    })
  ];
}
