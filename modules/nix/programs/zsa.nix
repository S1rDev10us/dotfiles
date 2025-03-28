{pkgs, ...}: {
  hardware.keyboard.zsa.enable = true;
  environment.systemPackages = with pkgs; [keymapp];
  unfreePackages = with pkgs; [keymapp];
}
