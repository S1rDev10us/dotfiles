{
  pkgs,
  inputs,
  ...
}: {
  programs.helix.defaultEditor = true;
  programs.niri.settings.input.tablet.map-to-output = "DP-2";
  home.packages = [
    inputs.tagstudio.packages.${pkgs.stdenv.hostPlatform.system}.tagstudio-jxl
  ];
}
