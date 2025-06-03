{pkgs, ...}: {
  home.packages = with pkgs; [helix];
  # programs.helix = {
  #   enable = true;
  #   extraConfig = builtins.readFile ./helix.toml;
  # };
}
