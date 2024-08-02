{
  stdenv,
  bun,
  rsync,
  ags,
  bash,
  dart-sass,
}:
stdenv.mkDerivation {
  pname = "ags-dots";
  version = "0.0.3";
  src = ./.;
  buildPhase = ''
    runHook preBuild

    echo "Linking ags types to local types"
    ln -s ${ags}/share/com.github.Aylur.ags/types ./types

    echo "Building with bun"
    bun build ./config.ts --outdir ./result/js --external 'resource://*' --external 'gi://*'

    echo "Building with sass"
    sass --trace 'style':'result/css'

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    echo "Creating output dir"
    mkdir $out

    echo "Copying most files using rsync"
    rsync -av --del --exclude '*.js' --exclude '*.ts' --exclude '*.scss' --exclude 'result/***' ./ $out/

    echo "Copying js"
    cp -r ./result/js/* $out

    echo "Copying css"
    cp -r ./result/css/* $out

    echo "Creating convience output script"
    mkdir $out/bin
    cat > $out/bin/ags-dots << EOF
    #!${bash}/bin/bash
    ${ags}/bin/ags -q && ${ags}/bin/ags -c $out/config.js
    EOF

    runHook postInstall
  '';
  postInstall = ''

    echo "Making convience output script executable"
    chmod +x $out/bin/ags-dots
  '';
  buildInputs = [bun rsync dart-sass ags];
}
