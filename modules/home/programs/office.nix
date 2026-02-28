{
  pkgs,
  lib,
  opts,
  ...
}: {
  home.packages = with pkgs;
    []
    ++ (lib.optionals opts.GUI ([
        libreoffice-qt
        unstable.super-productivity
        unstable.obsidian
        logseq
        # Should media creators be included in office?
        tenacity
      ]
      ++ (with kdePackages; [
        ark
        kate
        okular
      ])));
  unfreePackages = with pkgs; [
    unstable.obsidian
  ];
}
