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
    # ''
    #   spawn-at-startup "streamcontroller" "-b"
    # ''
    ''
      output "DP-2" {
        layout {
          default-column-width { proportion 0.33333; }
          preset-column-widths {
            proportion 0.25
            proportion 0.33333
            proportion 0.5
          }
        }
      }
    ''
  ];
  home.packages = [
    inputs.tagstudio.packages.${pkgs.stdenv.hostPlatform.system}.tagstudio-jxl
  ];
}
