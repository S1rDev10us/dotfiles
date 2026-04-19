{
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  programs.helix.defaultEditor = true;
  wayland.windowManager.hyprland.settings = {
    # Generated using `gtf` https://old.reddit.com/r/hyprland/comments/18fb0zp/looking_for_help_with_resolution/kcypu7w/
    monitor = lib.mkBefore ["eDP-1, modeline 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -hsync +vsync, 0x0, 1"];

    exec-once = lib.mkAfter [
      "[workspace 5 silent] foot -D ~/Documents/repos/pvp_spaceship_game/"
    ];
  };
  programs.niri.extraRules = [
    ''
      output "eDP-1" {
        scale 1.75
      }

      spawn-at-startup "obsidian"
      // spawn-at-startup "super-productivity"

      // spawn-at-startup "element-desktop"
      // spawn-at-startup "firefox" "-P" "comms" "--name" "firefox-comms"
      spawn-at-startup "discord"
    ''
    (let
      workspaces = ["web" "comms" "notes"];
      workspace = lib.listToAttrs (lib.map (ws: lib.nameValuePair ws ws) workspaces);
      window-rule = rules: ''
        window-rule {
          ${lib.join "\n  " (lib.flatten rules)}
        }
      '';
      onWorkspace = startupOnly: ws: apps: let
        atStartup =
          if startupOnly
          then " at-startup=true"
          else "";
      in
        window-rule [
          (lib.map (app-id: "match app-id=\"${app-id}\"${atStartup}") apps)
          ""
          "open-on-workspace \"${ws}\""
        ];
    in
      lib.join "\n" (lib.flatten [
        (lib.map (ws: "workspace \"${ws}\"") workspaces)
        (onWorkspace true workspace.web config.workspaces.web)
        (onWorkspace false workspace.comms config.workspaces.communications)
        (onWorkspace false workspace.notes config.workspaces.notes)
        # Obsidian started setting electron as it's id at some point
        ''
          window-rule {
            match title="Obsidian"

            open-on-workspace "${workspace.notes}"
          }
        ''
      ]))
  ];

}
