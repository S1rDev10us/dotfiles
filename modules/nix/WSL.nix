{
  inputs,
  config,
  lib,
  ...
}: let
  enable = config.settings.WSL.enable;
in {
  imports = [inputs.nixos-wsl.nixosModules.default];
  config = {
    programs.nix-ld = lib.mkIf enable {enable = true;};
    wsl = lib.mkIf enable {
      enable = true;
      defaultUser = "nixos";
    };
  };
}
