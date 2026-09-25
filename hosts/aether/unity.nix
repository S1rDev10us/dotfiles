{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    unityhub
  ];
  unfreePackages = [pkgs.unityhub pkgs.corefonts];
}
