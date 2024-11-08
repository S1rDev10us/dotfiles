{
  lib,
  opts,
  ...
}: {
  config = lib.mkIf opts.coding.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    programs.bash.interactiveShellInit = ''
      eval "$(direnv hook bash)"
    '';
  };
}
