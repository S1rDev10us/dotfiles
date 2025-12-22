{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;
    settings = lib.importTOML ../../../resources/helix/config.toml;
    languages = lib.importTOML ../../../resources/helix/languages.toml;
    ignores = [
      "target"
      "node_modules"
    ];
    extraPackages = with pkgs; [
      nil
      prettier
      ripgrep
    ];
  };
}
