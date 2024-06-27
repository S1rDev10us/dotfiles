{
  lib,
  config,
  opts,
  ...
}: {
  config = lib.mkIf opts.VM.enable {
    virtualisation.virtualbox.guest = {
      enable = true;
      clipboard = true;
    };
  };
}
