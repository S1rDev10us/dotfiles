{
  inputs,
  config,
  lib,
  pkgs,
  opts,
  ...
}: {
  imports = [inputs.nixos-wsl.nixosModules.default];
  config = lib.mkIf opts.WSL.enable {
    programs.nix-ld = {
      enable = true;
      # package = pkgs.nix-ld-rs;
    };
    wsl = {
      enable = true;
      defaultUser = "nixos";
    };
  };
}
