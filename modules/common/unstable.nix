{
  inputs,
  architecture,
  ...
}: {
  nixpkgs.overlays = [
    (
      final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          config = final.config;

          system = architecture;
        };
      }
    )
  ];
}
