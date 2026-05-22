{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: builtins.removeAttrs (inputs.nixpkgs-xr.overlays.default final prev) ["wivrn"])
  ];
  programs.steam = {
    # https://wiki.vronlinux.org/docs/distros/nixos/#steam-games-and-openvr-apps
    # Set PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES by default
    package = pkgs.steam.override {
      extraProfile = ''
        export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
      '';
    };

    remotePlay.openFirewall = true;
  };
  environment.systemPackages = with pkgs; [
    wayvr
  ];
  # Until https://github.com/WiVRn/WiVRn/issues/826 is patched, you need to run the following commands in order to fix Rumble not picking up tracking
  # cd ~/.local/share/Steam/steamapps/common/RUMBLE/RUMBLE_Data
  # nix shell nixpkgs#bbe
  # # Same number of 'A's as the length of the original string
  # bbe -e 's/XR_META_touch_controller_plus/AAAAAAAAAAAAAAAAAAAAAAAA/' globalgamemanagers.assets > globalgamemanagers.assets.2
  # mv globalgamemanagers.assets globalgamemanagers.assets.bak
  # mv globalgamemanagers.assets.2 globalgamemanagers.assets
  # stat globalgamemanagers.assets.bak
  # # Copy file permissions to new file
  # doas chmod 0755 globalgamemanagers.assets
  services.wivrn = {
    enable = true;
    openFirewall = true;
    package = pkgs.wivrn.override {cudaSupport = true;};
  };
  # services.wivern.openFirewall doesn't open 5353
  # https://discord.com/channels/1332686329800294462/1455795662108098631/1455821071671627827
  networking.firewall.allowedUDPPorts = [5353];
}
