{
  stdenv,
  pkgs,
  bun,
  rsync,
  ags,
  bash,
  dart-sass,
}:
stdenv.mkDerivation
(let
  agsPackage = ags.override {
    extraPackages = import ./dependencies.nix {inherit pkgs;};
    buildTypes = true;
  };
in {
  pname = "ags-dots";
  version = "0.0.3";
  src = ./.;
  preBuild = ''
    echo "Linking ags types to local types"
    ln -s ${agsPackage}/share/com.github.Aylur.ags/types ./types
  '';
  buildPhase = ''
    runHook preBuild

    echo "Building with bun"
    bun build ./config.ts --outdir ./result/js --external 'resource://*' --external 'gi://*'

    echo "Building with sass"
    sass --trace style/style.scss style.css

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    echo "Creating output dir"
    mkdir $out

    echo "Copying most files using rsync"
    rsync -avm --del \
      --exclude '*.js' \
      --exclude '*.ts' \
      --exclude '*.scss' \
      --exclude '*.nix' \
      --exclude 'tsconfig.json' \
      --exclude 'result' \
      --exclude 'types' \
      ./ $out/

    echo "Copying js"
    cp -r ./result/js/* $out

    echo "Creating convience output script"
    mkdir $out/bin
    cat > $out/bin/ags-dots << EOF
    #!${bash}/bin/bash
    ${agsPackage}/bin/ags -q && ${agsPackage}/bin/ags -c $out/config.js
    EOF

    runHook postInstall
  '';
  postInstall = ''

    echo "Making convience output script executable"
    chmod +x $out/bin/ags-dots
  '';
  buildInputs = [bun rsync dart-sass agsPackage];
})
