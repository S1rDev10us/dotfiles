{
  config,
  lib,
  pkgs,
  opts,
  ...
}: {
  config = lib.mkIf opts.fun.enable {
    programs.bash.bashrcExtra = "fastfetch";
    home.packages = [pkgs.fastfetch];
  };
}
