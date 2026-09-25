{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nixos-hardware.nixosModules.lenovo-legion-16iax10h];
  environment.systemPackages = with pkgs; [
    lenovo-legion
  ];
  boot.kernelModules = ["legion-laptop"];
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_7_2;

  nixpkgs.overlays = [
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
