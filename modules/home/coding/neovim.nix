{
  pkgs,
  lib,
  opts,
  ...
}:
lib.mkIf opts.coding.enable {
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
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
      rust-analyzer
    ];
    withNodeJs = true;
  };
}
