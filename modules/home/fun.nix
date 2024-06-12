{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.settings.fun.enable {
    programs.bash.bashrcExtra = "fastfetch";
    home.packages = [pkgs.fastfetch];
  };
}
