{pkgs, ...}: {
  home.packages = with pkgs; [helix nil];
  # programs.helix = {
  #   enable = true;
  #   extraConfig = builtins.readFile ./helix.toml;
  # };
}
