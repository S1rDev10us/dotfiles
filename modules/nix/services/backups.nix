# https://nixos.org/manual/nixos/stable/#module-borgbase
# https://wiki.nixos.org/wiki/Borg_backup
#
# To setup a new server
# Create the /etc/borg-backup folder
# Generate ssh key at /etc/borg-backup/id_$host_borgbackup with ssh-keygen
# Generate passphrase using PWM then save it in /etc/borg-backup/$host_borgbackup_passphrase
# `chmod go-r /etc/borg-backup/*`
#
# On the server
# Add the ssh public key to .ssh/authorised_keys with the same format as at https://borgbackup.readthedocs.io/en/stable/usage/serve.html#examples (or like the existing lines in the file)
# Create the repo using `borg init borg/$host -e repokey`. Paste in the passphrase from the PWM when requested
#
# Enable services.backups.enable in hosts/$host/default.nix
{
  config,
  lib,
  outputs,
  pkgs,
  ...
}: let
  hostname = config.networking.hostName;
  remote = "borgbackup@archimedes";
  repo = "${remote}:/home/borgbackup/borg/${hostname}";
  BORG_RSH = "${pkgs.openssh}/bin/ssh -i /etc/borg-backup/id_${hostname}_borgbackup";
  BORG_PASSCOMMAND = "cat /etc/borg-backup/${hostname}_borgbackup_passphrase";
in {
  services.borgbackup.jobs.backupToArchimedes = {
    paths = ["/home" "/etc" "/var/lib"];
    inhibitsSleep = true;
    persistentTimer = true;
    exclude = let
      freeformPathlist = val:
        lib.flatten (map (v:
          if lib.isAttrs v
          then lib.mapAttrsToList (path: children: map (cpath: path + "/" + cpath) (freeformPathlist children)) v
          else v) (lib.flatten (lib.toList val)));
    in
      freeformPathlist {
        "sh:home/*" = [
          # Caches
          ".cache"
          "**/.cache"
          "**/cache"
          "**/Code Cache"
          "**/GPUCache"
          "**/cache2"
          "**/Cache"
          "**/__pycache__"
          # Unity
          {
            "**/Library" = [
              "PackageCache"
              "Artifacts"
              "BurstCache"
            ];
          }
          # Trash
          ".local/share/Trash"
          "**/.caltrash"
          #
          # ".bash_history"
          ".cargo"
          {
            ".config" = [
              {
                BeeRef = [
                  "BeeRef.log"
                  "BeeRef.log1"
                ];
              }
              "discord"
            ];
          }
          ".debug"
          {
            ".local" = {
              "share" = [
                "baloo"
                "JetBrains"
                "NuGet"
                "nvim"
                "Steam"
              ];
              "state" = ["nvim"];
            };
          }
          ".nix-defexpr"
          ".nix-profile"
          ".npm"
          ".rustup/toolchains"
          {
            "Documents/repos/*" = [
              "target"
              ".direnv"
              "node_modules"
            ];
            "Downloads" = [
              "ISOs"
              "enwiki*"
              "Amphi backup drive backup"
            ];
          }
          "Unity"

          "Music/YTMusic"
          "Videos/Yt"

          # Backup of failed laptop
          "amphisbaena"
        ];
      };
    extraArgs = "--verbose --progress --show-rc";
    extraCreateArgs = "--stats";
    extraPruneArgs = "--stats";
    failOnWarnings = true;
    inherit repo;
    encryption = {
      mode = "repokey";
      passCommand = BORG_PASSCOMMAND;
    };
    environment.BORG_RSH = BORG_RSH;
    # manually set to true initially
    doInit = lib.mkDefault false;
    compression = "auto,lzma";
    startAt = "daily";
    preHook = ''
      if [ -z "$disable_network_check" ]; then
          until ${outputs.packages.${pkgs.stdenv.hostPlatform.system}.onhomenetwork}/bin/onhomenetwork.bash; do sleep 10; done
      fi
    '';
  };
  environment.systemPackages =
    [
      (pkgs.writeShellScriptBin "backup-listen" ''
        journalctl -u borgbackup-job-backupToArchimedes.service -f -o short-iso --no-hostname
      '')
      (pkgs.writeShellScriptBin "backup-history" ''
        journalctl -u borgbackup-job-backupToArchimedes.service -o short-iso --no-hostname
      '')
      (pkgs.writeShellScriptBin "backup-start" ''
        systemctl restart borgbackup-job-backupToArchimedes.service
      '')
      (pkgs.writeShellScriptBin "backup-status" ''
        systemctl status borgbackup-job-backupToArchimedes.service
      '')
    ]
    ++ (let
      borg = ''BORG_PASSCOMMAND="${BORG_PASSCOMMAND}" BORG_RSH="${BORG_RSH}" doas borg'';
    in [
      (pkgs.writeShellScriptBin "backup-mount" ''
        doas bash - << EOF
        mkdir /mnt/backup
        ${borg} mount ${repo} /mnt/backup
        EOF
      '')
      (pkgs.writeShellScriptBin "backup-umount" ''
        doas borg umount /mnt/backup
        doas rmdir /mnt/backup
      '')
      (pkgs.writeShellScriptBin "backup-list" ''
        ${borg} list ${repo}
      '')
      (pkgs.writeShellScriptBin "backup-check" ''
        ${borg} check ${repo} -p -v
      '')
    ]);
}
