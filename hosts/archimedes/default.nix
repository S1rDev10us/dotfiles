{
  architecture = "aarch64-linux";
  stateVersion = "24.11";
  toggles = {
    unstable.enable = true;
    unfree.enable = true;
    common.enable = true;
    users.enable = true;

    programs.doas.enable = true;
    programs.helix.enable = true;

    services.ssh.enable = true;
  };
  users.nixos = {
    enable = true;
  };
}
