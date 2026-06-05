{
  pkgs,
  inputs,
  ...
}: {
  programs.helix.defaultEditor = true;
  programs.niri.extraRules = [
    ''
      input {
        tablet {
          map-to-output "DP-2"
        }
      }
    ''
    ''
      spawn-at-startup "streamcontroller" "-b"
    ''
  ];
  home.packages = [
    inputs.tagstudio.packages.${pkgs.stdenv.hostPlatform.system}.tagstudio-jxl
  ];
}
