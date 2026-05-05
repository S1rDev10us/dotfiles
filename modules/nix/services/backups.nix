# https://nixos.org/manual/nixos/stable/#module-borgbase
# https://wiki.nixos.org/wiki/Borg_backup
{
  config,
  lib,
  outputs,
  pkgs,
  ...
}: let
  hostname = config.networking.hostName;
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
          }
          "Downloads/ISOs"
          "Downloads/enwiki*"
          "Unity"

          "Music/YTMusic"
          "Videos/Yt"
        ];
      };
    extraArgs = "--verbose --progress --show-rc";
    extraCreateArgs = "--stats";
    extraPruneArgs = "--stats";
    failOnWarnings = true;
    repo = "borgbackup@archimedes:/home/borgbackup/borg/${hostname}";
    encryption = {
      mode = "repokey";
      passCommand = "cat /etc/borg-backup/${hostname}_borgbackup_passphrase";
    };
    environment.BORG_RSH = "${pkgs.openssh}/bin/ssh -i /etc/borg-backup/id_${hostname}_borgbackup";
    # manually set to true initially
    doInit = lib.mkDefault false;
    compression = "auto,lzma";
    startAt = "daily";
    preHook = ''
      until ${outputs.packages.${pkgs.stdenv.hostPlatform.system}.onhomenetwork}/bin/onhomenetwork.bash; do sleep 10; done
    '';
  };
  environment.systemPackages = [
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

    (pkgs.writeShellScriptBin "backup-mount" ''
      BORG_PASSCOMMAND="cat /etc/borg-backup/${hostname}_borgbackup_passphrase" BORG_RSH="ssh -i /etc/borg-backup/id_${hostname}_borgbackup" doas borg mount borgbackup@archimedes:/home/borgbackup/borg/${hostname} /mnt/backup
    '')
    (pkgs.writeShellScriptBin "backup-umount" ''
      doas borg umount /mnt/backup
      doas rmdir /mnt/backup
    '')
  ];
}
