{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ffmpeg
  ];
}
