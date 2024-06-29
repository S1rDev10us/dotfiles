{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    obs-studio
    inkscape
    gimp
    blender

    discord
    jetbrains.rider
  ];
  unfreePackages = with pkgs; [
    jetbrains.rider
    discord
  ];
}
