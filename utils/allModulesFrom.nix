{lib, ...}: path: let
  func = obj: currentPath: (
    builtins.mapAttrs (name: value: let
      newPath = lib.path.append currentPath name;
    in
      if value == "directory"
      then (func (builtins.readDir newPath)) newPath
      else newPath)
    (lib.pipe obj [
      # Ignore symlinks/other abnormal file types
      (lib.filterAttrs (_: type: (builtins.elem type ["regular" "directory" ""])))
      # Filter out files that aren't nix modules (end with .nix)
      (lib.filterAttrs (path: type: type != "regular" || lib.hasSuffix ".nix" (builtins.toString path)))
    ])
  );
in
  (lib.collect builtins.isPath) ((func (builtins.readDir path)) path)
