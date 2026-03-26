{
  pkgs,
  lib,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      inter
    ];
    fontconfig.defaultFonts = {monospace = lib.mkBefore ["JetBrainsMono NF" "Jetbrains Mono" "Fira Code"];};
    enableDefaultPackages = true;
  };
}
