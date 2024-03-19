{
  lib,
  userConfig,
  pkgs,
  ...
}: {
  config = lib.mkIf userConfig.games {
    # Allow unfree packages (this includes most games)
    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      minecraft
    ];
    # Enable steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
    };
  };
}
