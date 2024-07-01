{env, ...}: {
  # environment.gnome.enable = true;
  # Temporarily manage hyprland imperatively until I get home manager sorted for hyprland
  environment.hyprland.enable = env == "nixos";
  GUI.enable = true;
  coding.enable = true;
  users.s1rdev10us.enable = true;
}
