{
  lib,
  config,
  pkgs,
  opts,
  ...
}: {
  config = lib.mkIf opts.coding.enable {
    environment.systemPackages = with pkgs;
      [
        alejandra
        nixd
        nil
        git
        just
      ]
      ++ lib.optionals opts.GUI.enable [
        vscode
      ];
    unfreePackages = lib.optionals opts.GUI.enable [pkgs.vscode];
  };
}
