{
  pkgs,
  lib,
  opts,
  ...
}: {
  environment.systemPackages = with pkgs;
    []
    ++ (lib.optionals opts.GUI [
      ark
      kate
      libreoffice-qt
      okular
      super-productivity
      unstable.obsidian
      # Should media creators be included in office?
      inkscape
      gimp
      krita
      blender
      tenacity
    ]);
  unfreePackages = with pkgs; [
    unstable.obsidian
  ];
}
