{
  lib,
  libx,
  ...
}: pathList: config: let
  allPathSections = [] ++ lib.imap1 (i: _: lib.sublist 0 i pathList) pathList;
  enabledAtPath = path: let
    enabledPath = ["toggles"] ++ path ++ ["enable"];
  in
    lib.attrByPath enabledPath true config;
in
  lib.all enabledAtPath allPathSections
