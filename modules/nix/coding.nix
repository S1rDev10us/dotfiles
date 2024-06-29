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
      ]
      ++ lib.optionals opts.GUI.enable [
        vscode
        unityhub
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
