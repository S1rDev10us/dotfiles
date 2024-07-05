{
  opts,
  lib,
  pkgs,
  ...
}:
lib.mkIf opts.GUI.enable {
  environment.systemPackages = with pkgs; [keepassxc];
}
