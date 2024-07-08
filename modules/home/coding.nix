{
  pkgs,
  lib,
  opts,
  ...
}:
lib.mkIf opts.coding.enable {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # Mason dependencies
    extraPackages = with pkgs; [nodejs_22 dotnetCorePackages.dotnet_8.sdk unzip rustup wget];
  };
}
