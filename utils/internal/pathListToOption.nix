{lib, ...}: pathList: let
  # prefix = ["options"];
  suffix = ["enable"];
  # fullList = prefix ++ pathList ++ suffix;
  fullList = pathList ++ suffix;

  actualFileName = lib.last pathList;
  isDefault = actualFileName == "default";

  # .../a/b.nix => b
  # .../a/default.nix => a
  moduleName =
    if !isDefault
    then actualFileName
    else (lib.last (lib.init pathList));

  option = lib.mkEnableOption moduleName;
in
  lib.setAttrByPath fullList option
