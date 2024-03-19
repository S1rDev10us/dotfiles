{
  config,
  pkgs,
  stylix,
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
  stylix.autoEnable = false;
  stylix.targets = {
    grub.enable = false;
    plymouth.enable = false;
    gnome.enable = userConfig.desktop-environment == "gnome";
    gtk.enable = userConfig.desktop-environment == "gnome";
  };

  stylix.polarity = "dark";

  stylix.image = pkgs.fetchurl (builtins.fromTOML (builtins.readFile (../../themes/backgrounds/. + (userConfig.background.toml))));
  home-manager.sharedModules = [
    {
      stylix.autoEnable = false;
      stylix.targets = {
        firefox.enable = true;
        vscode.enable = true;
        gnome.enable = true;
        gtk.enable = true;
        tmux.enable = true;
      };
    }
  ];
}
