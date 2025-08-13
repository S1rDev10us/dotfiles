{
  pkgs,
  lib,
  opts,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
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
