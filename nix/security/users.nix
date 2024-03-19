{userConfig, ...}: {
  # Login service
  services.xserver.displayManager.gdm.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${userConfig.username}" = {
    isNormalUser = true;
    description = userConfig.name;
    extraGroups = ["networkmanager" "wheel"];
  };
}
