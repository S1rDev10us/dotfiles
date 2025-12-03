{
  pkgs,
  lib,
  opts,
  inputs,
  ...
}: let
  beeref = pkgs.callPackage (import (inputs.nixpkgs-unstable + "/pkgs/by-name/be/beeref/package.nix")) {};
in {
  home.packages = with pkgs;
    []
    ++ (lib.optionals opts.GUI [
      beeref
      inkscape
      gimp
      krita
      blender
    ]);
  xdg.enable = true;
  xdg.desktopEntries = {
    beeref = {
      name = "Beeref";
      genericName = "Image Viewer";
      comment = "A simple reference image viewer";
      exec = "beeref %f";
      terminal = false;
      type = "Application";
      categories = ["Application" "Graphics" "Qt" "KDE"];
      icon = "${beeref}/lib/python3.13/site-packages/beeref/assets/logo.png";
      mimeType = ["application/x-beeref"];
    };
  };
}
