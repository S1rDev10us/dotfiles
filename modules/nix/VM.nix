{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.settings.VM.enable {
    virtualisation.virtualbox.guest = {
      enable = true;
      x11 = true;
    };
  };
}
