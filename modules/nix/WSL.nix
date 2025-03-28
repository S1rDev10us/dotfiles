{
  inputs,
  lib,
  opts,
  ...
}: {
  useOpts = true;
  imports = lib.optional opts.toggles.WSL.enable inputs.nixos-wsl.nixosModules.default;
  config =
    if opts.toggles.WSL.enable
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
