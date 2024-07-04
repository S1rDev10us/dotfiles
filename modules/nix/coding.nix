{
  lib,
  config,
  pkgs,
  opts,
  ...
}: {
  config = lib.mkIf opts.coding.enable {
    programs.git.enable = true;
    environment.systemPackages = with pkgs;
      [
        alejandra
        nixd
        nil
        just
        neovim
        rustup
      ]
      ++ lib.optionals opts.GUI.enable [
        vscode
        unityhub
        neovide
        jetbrains-toolbox
        jetbrains.rider
      ];
    unfreePackages = lib.optionals opts.GUI.enable (with pkgs; [
      vscode
      unityhub
      jetbrains-toolbox
      jetbrains.rider
    ]);
  };
}
