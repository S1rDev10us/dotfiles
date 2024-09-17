{
  just,
  stdenvNoCC,
  bash,
}:
stdenvNoCC.mkDerivation rec {
  pname = "devlogs";
  version = "0.0.1";
  src = ./.;
  buildPhase = ''
    runHook preBuild



    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    mkdir $out/bin
    cat > $out/bin/${pname} << EOF
    #!${bash}/bin/bash

    # Insert command to run compiled package here
    EOF

    runHook postInstall
  '';
  postInstall = ''
    chmod +x $out/bin/${pname}
  '';
  buildInputs = [just];
}
