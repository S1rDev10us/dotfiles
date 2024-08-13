{env, ...}: {
  # environment.gnome.enable = true;
  # Temporarily manage hyprland imperatively until I get home manager sorted for hyprland
  environment.hyprland.enable = env == "nixos";
  stateVersion = "23.11";
  GUI.enable = true;
  coding.enable = true;
  users.s1rdev10us = {
    enable = true;
    admin = true;
  };
}
