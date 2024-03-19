{
  lib,
  systemConfig,
  pkgs,
  ...
}: {
  config = lib.mkIf (!systemConfig.headless) {
    # Allow unfree packages for discord and obsidian
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      discord

      unityhub
      unstable.obsidian
      obs-studio
      vscode
      inkscape
      gimp

      blender
      gparted

      newsflash
    ];
  };
}
