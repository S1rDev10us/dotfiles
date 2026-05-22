{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: builtins.removeAttrs (inputs.nixpkgs-xr.overlays.default final prev) ["wivrn"])
  ];
  programs.steam.remotePlay.openFirewall = true;
  environment.systemPackages = with pkgs; [
    wayvr
  ];
  services.wivrn = {
    enable = true;
    openFirewall = true;
  };
  # services.wivern.openFirewall doesn't open 5353
  # https://discord.com/channels/1332686329800294462/1455795662108098631/1455821071671627827
  networking.firewall.allowedUDPPorts = [5353];
}
