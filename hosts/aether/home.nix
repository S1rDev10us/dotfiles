{
  lib,
  config,
  pkgs,
  outputs,
  ...
}: {
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     blender = prev.blender.override {
  #       config.cudaSupport = true;
  #       config.rocmSupport = false;
  #     };
  #   })
  # ];
  # unfreePackages = [pkgs.blender (pkg: pkg ? "meta" && pkg.meta ? "license" && lib.lists.all (license: license.shortName == "CUDA EULA") (lib.lists.toList pkg.meta.license))];
  programs.niri.extraRules = [
    ''
      output "eDP-1" {
        scale 1.0
      }
    ''

    #   spawn-at-startup "obsidian"
    #   // spawn-at-startup "super-productivity"

    #   // spawn-at-startup "element-desktop"
    #   // spawn-at-startup "firefox" "-P" "comms" "--name" "firefox-comms"
    #   spawn-at-startup "discord"
    # ''
    # (let
    #   workspaces = ["web" "comms" "notes"];
    #   workspace = lib.listToAttrs (lib.map (ws: lib.nameValuePair ws ws) workspaces);
    #   window-rule = rules: ''
    #     window-rule {
    #       ${lib.join "\n  " (lib.flatten rules)}
    #     }
    #   '';
    #   onWorkspace = startupOnly: ws: apps: let
    #     atStartup =
    #       if startupOnly
    #       then " at-startup=true"
    #       else "";
    #   in
    #     window-rule [
    #       (lib.map (app-id: "match app-id=\"${app-id}\"${atStartup}") apps)
    #       ""
    #       "open-on-workspace \"${ws}\""
    #     ];
    # in
    #   lib.join "\n" (lib.flatten [
    #     (lib.map (ws: "workspace \"${ws}\"") workspaces)
    #     (onWorkspace true workspace.web config.workspaces.web)
    #     (onWorkspace false workspace.comms config.workspaces.communications)
    #     (onWorkspace false workspace.notes config.workspaces.notes)
    #     # Obsidian started setting electron as it's id at some point
    #     ''
    #       window-rule {
    #         match title="Obsidian"
    #         match title="Super Productivity"

    #         open-on-workspace "${workspace.notes}"
    #       }
    #     ''
    #   ]))
  ];
}
