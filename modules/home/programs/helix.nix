{
  programs.helix = {
    enable = true;
    extraConfig = builtins.readFile ./helix.toml;
  };
}
