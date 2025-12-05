{inputs, ...}: {
  imports = [
    inputs.niri.nixosModules.niri
  ];
  niri-flake.cache.enable = false;
  programs.niri = {
    enable = true;
  };

  systemd.user.services.niri-flake-polkit.enable = false;
}
