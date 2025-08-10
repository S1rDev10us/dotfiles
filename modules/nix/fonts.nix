{
  pkgs,
  lib,
  ...
}: {
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
  fonts.fontconfig.defaultFonts = {monospace = lib.mkBefore ["JetBrainsMono NF" "Jetbrains Mono" "Fira Code"];};
}
