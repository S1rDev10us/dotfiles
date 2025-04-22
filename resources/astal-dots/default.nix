{
  ags,
  pkgs,
  ...
}: let
  bundle = executable: entrypoint: extraPackages:
    ags.lib.bundle {
      inherit pkgs;
      src = ./.;
      name = executable;
      entry = entrypoint;
      gtk4 = false;

      extraPackages = extraPackages;
    };
in {
  audio-bar = bundle "audio-bar" "app-audio.tsx" [ags.packages.${pkgs.system}.cava];
}
