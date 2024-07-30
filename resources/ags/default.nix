{stdenv}: let
  buildDependencies = [];
in
  stdenv.mkDerivation {
    pname = "ags-dots";
    version = "0.0.1";
    src = ./.;
    postInstall = ''
      mkdir $out
      cp -v * $out/
    '';
  }
