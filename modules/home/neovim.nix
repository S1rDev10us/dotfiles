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
    extraPackages = with pkgs; [
      dotnetCorePackages.dotnet_8.sdk
      unzip
      rustup
      wget
      nodePackages.prettier
      prettierd
      nixd
      nil
      alejandra
      fzf
      ripgrep
      lazygit
    ];
    withNodeJs = true;
  };
}
