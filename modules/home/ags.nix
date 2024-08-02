{
  pkgs,
  opts,
  inputs,
  lib,
  config,
  ...
}: {
  imports = [inputs.ags.homeManagerModules.default];
  config = lib.mkIf opts.environment.hyprland.enable {
    programs.ags = {
      enable = true;
      configDir = "${pkgs.callPackage ../../resources/ags-dots/default.nix {}}";
      extraPackages = import ../../resources/ags-dots/dependencies.nix {inherit pkgs;};
    };
    systemd.user.services.ags = {
      Unit = {
        Description = "Systemd service for agS";
        PartOf = ["hyprland-session.target"];
      };
      Service = {
        ExecStart = "${config.programs.ags.finalPackage}/bin/ags";
        Restart = "on-failure";
      };
      Install.WantedBy = ["hyprland-session.target"];
    };
  };
}
