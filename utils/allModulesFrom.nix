{lib, ...}: path: let
  func = obj: currentPath: (
    builtins.mapAttrs (name: value: let
      newPath = lib.path.append currentPath name;
    in
      if value == "directory"
      then (func (builtins.readDir newPath)) newPath
      else newPath)
    (lib.filterAttrs (_: type: (builtins.elem type ["regular" "directory" ""])) obj)
  );
in
  (lib.collect builtins.isPath) ((func (builtins.readDir path)) path)
