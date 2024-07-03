{
  lib,
  libx,
  opts,
  ...
}: {
  users.users = lib.genAttrs (libx.getEnabledUsers opts) (username: let
    user = opts.users."${username}";
  in {
    isNormalUser = true;
    extraGroups = [] ++ (lib.optionals user.admin ["wheel" "networkmanager"]);
  });
}
