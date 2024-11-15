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
  cavaBarCount = 20;
  cavaRaw = pkgs.writeShellScript "cava" ''
    ${pkgs.cava}/bin/cava -p ${pkgs.writeText "cava-config" ''
      [general]
      bars=${builtins.toString cavaBarCount}
      mode=normal
      autosens=1
      framerate=40
      [output]
      method=raw
      raw_target=/dev/stdout
      bit_format=8bit
      data_format=ascii
      ascii_max_range=255

      channels=mono
      mono_option=average
    ''}
  '';
in rec {
  pname = "ags-dots";
  version = "0.0.4";
  src = ./.;
  preBuild = ''
    echo "Linking ags types to local types"
    ln -s ${agsPackage}/share/com.github.Aylur.ags/types ./types

    echo "Passing useful parameters to config"
    cat > params.ts << EOF
    export const cava="${cavaRaw}";
    export const cavaBarCount="${builtins.toString cavaBarCount}";
    EOF

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
    cat > $out/bin/${pname} << EOF
    #!${bash}/bin/bash
    ${agsPackage}/bin/ags -q && ${agsPackage}/bin/ags -c $out/config.js
    EOF

    runHook postInstall
  '';
  postInstall = ''

    echo "Making convience output script executable"
    chmod +x $out/bin/${pname}
  '';
  buildInputs = [bun rsync dart-sass agsPackage];
})
