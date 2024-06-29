{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    obs-studio
    inkscape
    gimp
    blender

    discord
  ];
  unfreePackages = with pkgs; [
    discord
  ];
}
