{
  pkgs,
  lib,
  opts,
  ...
}: {
  environment.systemPackages = let
    cfg = opts.toggles.programs.open-preset-apps;
    apps-to-run = cfg.apps-to-run;
    spawn-app = cfg.spawn-app;

    open-preset-apps = pkgs.writeShellScriptBin "open-preset-apps" (
      lib.join "\n" (lib.map spawn-app apps-to-run)
    );
  in [
    (pkgs.symlinkJoin {
      name = "open-preset-apps-joined";
      paths = [
        open-preset-apps
        (pkgs.makeDesktopItem {
          name = "open-preset-apps";
          desktopName = "Open preset apps (run once on most startups)";
          exec = lib.getExe open-preset-apps;
        })
      ];
    })
  ];
}
