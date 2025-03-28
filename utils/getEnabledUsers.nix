{lib, ...}: opts: (builtins.filter
  (user: opts.users."${user}".enable)
  (builtins.attrNames opts.users))
