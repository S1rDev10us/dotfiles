{
  pkgs,
  systemConfig,
  ...
}: let
  script = pkgs.writeShellApplication {
    name = "nixos-rebuild-system";
    runtimeInputs = with pkgs; [
      alejandra
      git
      gnugrep
    ];
    text = ''

      # Inspired by https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5
      set -e
      pushd ${systemConfig.configLocation}

      git add --intent-to-add settings.json
      git add --intent-to-add nix/hardware/hardware-configuration.nix
      git update-index --assume-unchanged settings.json
      git update-index --assume-unchanged nix/hardware/hardware-configuration.nix

      # Check if there are remote git changes, if there are make the user resolve them
      UPSTREAM=''${1:-'@{u}'}
      LOCAL=''$(git rev-parse @)
      BASE=''$(git merge-base @ "''$UPSTREAM")

      if [ "''$LOCAL" = "''$BASE" ]; then

      	notify-send -e "There are remote changes on the git branch. Please resolve the changes and make sure that there are no conflicts"
      	exit 0
      fi


      if git diff --quiet -- *.{nix,json}; then
        echo "No changes detected"
        exit 0
      fi

      alejandra .


      # show changes
      git diff -U0 -- '*.nix' 'settings.json'

      echo "Rebuilding!"

      sudo nixos-rebuild switch
      gitGenerationUnmodified=''$(git rev-list --count HEAD)
      gitGeneration=''${gitGenerationUnmodified+1}
      # shellcheck disable=SC2016
      localGeneration=''$(nix-env --list-generations | grep current | awk '{print ''$1}')

      git commit -am "Generation ''$gitGeneration (Local:''$localGeneration)"

      sudo nix-env --delete-generations +5
      sudo nix-store --gc

      # Notify all OK!
      notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available

      popd

    '';
  };
  desktopItem = pkgs.makeDesktopItem {
    name = "nixos-rebuild-system";
    desktopName = "Rebuild Nix system";
    exec = "${script}/bin/nixos-rebuild-system";
    terminal = true;
  };
in {
  environment.systemPackages = [
    script
    desktopItem
  ];
  # home-manager.sharedModules = [
  #   {
  #     home.packages = [
  #     ];
  #   }
  # ];
}
