{
  inputs,
  lib,
  opts,
  ...
}: {
  imports = lib.optional opts.WSL.enable inputs.nixos-wsl.nixosModules.default;
  config =
    if opts.WSL.enable
    then {
      programs.nix-ld = {
        enable = true;
        # package = pkgs.nix-ld-rs;
      };
      wsl = {
        enable = true;
        defaultUser = "nixos";
      };
    }
    else {};
}
