{
  lib,
  opts,
  ...
}: {
  programs.foot = {
    enable = opts.GUI.enable;
    settings = {
      main = {
        font = "JetbrainsMonoNF:size=10";
      };
    };
  };
}
