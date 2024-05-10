{
  pkgs,
  userConfig,
  lib,
  ...
}: {
  imports = [
    # stylix.nixosModules.stylix # Needs to be imported in the flakes files apparently
    (lib.mkIf (userConfig.theme != "") {
      stylix.base16Scheme = ../../themes/base16/. + "/${userConfig.theme}.yaml";
    })
  ];
  stylix = {
    autoEnable = true;
    targets = {
      grub.enable = false;
      plymouth.enable = false;
      waybar = {
        enableCenterBackColors = true;
        enableLeftBackColors = true;
        enableRightBackColors = true;
      };
    };
    polarity = "dark";
    image = pkgs.fetchurl (builtins.fromTOML (builtins.readFile (../../themes/backgrounds/. + (userConfig.background.toml))));
    opacity = {
      applications = 0.0;
      desktop = 1.0;
      popups = 0.0;
      terminal = 0.0;
    };
  };

  home-module = {
    stylix.autoEnable = true;
    stylix.targets = {
      firefox.enable = true;
      vscode.enable = true;
      gnome.enable = true;
      gtk.enable = true;
      tmux.enable = true;
    };
  };
}
