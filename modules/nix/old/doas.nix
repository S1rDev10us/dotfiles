{
  pkgs,
  lib,
  config,
  ...
}: {
  security = {
    doas = {
      enable = true;
      extraRules = [
        {
          groups = ["wheel"];
          persist = true;
          keepEnv = true;
        }
      ];
    };
    sudo = {
      enable = false;
      execWheelOnly = true;
    };
  };
  environment.systemPackages = lib.optional (!config.security.sudo.enable) (pkgs.writeScriptBin "sudo" ''exec doas "$@"'');
}
