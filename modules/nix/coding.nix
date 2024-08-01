{
  lib,
  pkgs,
  opts,
  ...
}: {
  config = lib.mkIf opts.coding.enable {
    environment.systemPackages = with pkgs;
      [
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
    programs = {
      git.enable = true;
      nix-ld = {
        enable = true;
        libraries = with pkgs; [openssl stdenv.cc.cc mesa];
      };
    };
    # environment.variables.NIX_LD = lib.makeLibraryPath (with pkgs; [openssl]);
  };
}
