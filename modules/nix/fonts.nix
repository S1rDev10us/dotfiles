{
  pkgs,
  lib,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      inter
      roboto-slab
    ];
    fontconfig.defaultFonts = {
      serif = lib.mkBefore ["Roboto Slab"];
      sansSerif = lib.mkBefore ["Inter"];
      monospace = lib.mkBefore ["JetBrainsMono NF" "Jetbrains Mono" "Fira Code"];
    };
    enableDefaultPackages = true;
  };
}
