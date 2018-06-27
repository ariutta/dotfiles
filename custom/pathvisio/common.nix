{ stdenv, fetchurl, fetchFromGitHub, makeDesktopItem, unzip, ant, jdk, desktop, datasources, buildType }:

let
  baseName = "PathVisio";
  version = "3.3.0";
in
with builtins;
stdenv.mkDerivation rec {
  name = concatStringsSep "-" (filter (x: isString x) [baseName version buildType]);

  # should this be nativeBuildInputs or just buildInputs?
  nativeBuildInputs = [ unzip ant jdk ];

  javaPath = "${jdk.jre}/bin/java";

  libPath0 = "../lib";
  libPath1 = "$out/lib/pathvisio";

  modulesPath0 = "../modules";
  modulesPath1 = "${libPath1}/modules";

  sharePath1 = "$out/share/pathvisio";

  # TODO look into giving the option to use a local download of the datasources
  #datasourcesFlags = builtins.reduce datasources
  # once the above is figured out, it might be possible to append
  # datasourcesFlags to pathvisioJarCpCmd
  #datasourcesFlags = builtins.concatStringsSep " " (builtins.map (d: "-p " + d) datasources);
  datasourcesFlags = concatStringsSep " " (map (d: "-p " + d) datasources);

  pathvisioExec = ''
    ${javaPath} -jar -Dfile.encoding=UTF-8 ${sharePath1}/pathvisio.jar ${datasourcesFlags} "\$@"
  '';

  pathvisioJarCpCmd = ''
    cat > $out/bin/pathvisio <<EOF
    #! $shell
    cd \$(dirname \$0)
    ${pathvisioExec}
    EOF

    chmod a+x $out/bin/pathvisio

    mkdir -p "${sharePath1}"
    cp ./pathvisio.jar "${sharePath1}/pathvisio.jar"
  '';

  src = fetchFromGitHub {
    owner = "pathvisio";
    repo = "PathVisio";
    rev = "61f15de96b676ee581858f0485f9c6d8f61a3476";
    sha256 = "1n2897290g6kph1l04d2lj6n7137w0gnavzp9rjz43hi1ggyw6f9";
  };

  biopax3GPMLSrc = fetchurl {
    url = "https://cdn.rawgit.com/wikipathways/wikipathways.org/e8fae01e/wpi/bin/Biopax3GPML.jar";
    sha256 = "1jm5khh6n78fghd7wp0m5dcb6s2zp23pgsbw56rpajfxgx1sz7lg";
  };

  pngIconSrc = "${src}/www/bigcateye_135x135.png";

  iconSrc = "${src}/lib-build/bigcateye.icns";

  postPatch = ''
    for f in ./scripts/*; do
      substituteInPlace $f \
            --replace "java -ea" "${javaPath} -ea" \
            --replace "#!/bin/sh" "#!$shell" \
            --replace "#!/bin/bash" "#!$shell"
    done
  '';

  buildPhase = (if ! desktop then "ant"
  else if stdenv.system == "x86_64-darwin" then "ant appbundler"
  else "ant exe") + ''

    mkdir -p ./bin
    cp ./scripts/gpmldiff.sh ./bin/gpmldiff
    cp ./scripts/gpmlpatch.sh ./bin/gpmlpatch

    cat > ./bin/gpmlconvert <<EOF
    #! $shell
    CLASSPATH=${modulesPath0}/org.pathvisio.core.jar:${libPath0}/*:${biopax3GPMLSrc}
    ${javaPath} -ea -classpath \$CLASSPATH org.pathvisio.core.util.Converter "\$@"
    EOF

    chmod a+x ./bin/gpmlconvert
    chmod a+x ./bin/gpmldiff
    chmod a+x ./bin/gpmlpatch
  '';

  doCheck = true;

  checkPhase = ''
    # TODO are we running the existing tests?
    cd ./bin
    ./gpmlconvert ../example-data/Hs_Apoptosis.gpml Hs_Apoptosis.pdf
    rm Hs_Apoptosis.pdf
    ./gpmlconvert ../example-data/Hs_Apoptosis.gpml Hs_Apoptosis.png
    rm Hs_Apoptosis.png
    ./gpmlconvert ../example-data/Hs_Apoptosis.gpml Hs_Apoptosis.owl
    rm Hs_Apoptosis.owl
    ./gpmldiff ../example-data/Hs_Apoptosis.gpml ../example-data/Hs_Cell_cycle_KEGG.gpml
    rm Hs_Apoptosis.bpss
    cd ../
  '';

  desktopItem = makeDesktopItem {
    name = name;
    exec = "pathvisio";
    icon = "${pngIconSrc}";
    desktopName = baseName;
    genericName = "Pathway Editor";
    comment = meta.description;
    # See https://specifications.freedesktop.org/menu-spec/latest/apa.html
    categories = "Editor;Science;Biology;DataVisualization;";
    mimeType = "application/gpml+xml";
    terminal = "false";
  };

  # TODO Should we somehow take advantage of the osgi and apache capabilities?
  installPhase = ''
    mkdir -p "$out/bin" "${libPath1}" "${modulesPath1}"

    cp -r ./bin/* $out/bin/
    for f in $out/bin/*; do
      substituteInPlace $f \
            --replace "${libPath0}" "${libPath1}" \
            --replace "${modulesPath0}" "${modulesPath1}"
    done

    cp -r ./lib/* "${libPath1}/"
    cp -r ./modules/* "${modulesPath1}/"

    echo 'Sample commands:'
    echo '  # Get some data'
    echo '  wget https://cdn.rawgit.com/PathVisio/GPML/fa76a73d/test/2013a/WP1243_69897.gpml'
    echo '  cp WP1243_69897.gpml test.gpml'
    echo '  # GPML -> BioPAX/OWL'
    echo '  gpmlconvert WP1243_69897.gpml WP1243_69897.owl'
    echo '  # GPML -> PDF'
    echo '  gpmlconvert WP1243_69897.gpml WP1243_69897.pdf'
    echo '  # GPML -> PNG'
    echo '  gpmlconvert WP1243_69897.gpml WP1243_69897.png'
    echo '  # Diff'
    echo '  gpmldiff WP1243_69897.gpml test.gpml > test.diff'
    echo '  # Patch'
    echo '  gpmlpatch WP1243_69897.gpml < test.diff'
  '' + (
  if ! desktop then ''
    echo 'desktop functionality not enabled'
  '' else if stdenv.system == "x86_64-darwin" then ''
    # NOTE: duplicated below
    ${pathvisioJarCpCmd}

    mkdir -p "$out/Applications"
    unzip -o release/${baseName}.app.zip -d "$out/Applications/"
  '' else ''
    # NOTE: duplicated above
    ${pathvisioJarCpCmd}

    mkdir -p "$out/share/applications"
    ln -s ${desktopItem}/share/applications/* "$out/share/applications/"
  '');

  meta = with stdenv.lib;
    { description = "A tool to edit and analyze biological pathways";
      homepage = https://www.pathvisio.org/;
      license = licenses.asl20;
      maintainers = with maintainers; [ ];
      platforms = platforms.all;
    };
}
