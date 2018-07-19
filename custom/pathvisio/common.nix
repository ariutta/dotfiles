{ stdenv, coreutils, fetchurl, fetchFromGitHub, makeDesktopItem, unzip, ant, jdk, desktop ? true, organism ? "Homo sapiens", datasources ? [] }:
# TODO allow for specifying plugins to install

with builtins;

let
  baseName = "PathVisio";
  version = "3.3.0";
in
stdenv.mkDerivation rec {
  name = replaceStrings [" "] ["_"] (concatStringsSep "-" (filter (x: isString x) [baseName version organism]));

  # should this be nativeBuildInputs or just buildInputs?
  nativeBuildInputs = [ unzip ant jdk ];
  buildInputs = map (d: d.src) datasources;

  pathwayStub = ./pathway.gpml;
  pathvisioPlugins = ./pathvisio.xml;

  bridgedbSettings = fetchurl {
    url = "http://repository.pathvisio.org/plugins/pvplugins-bridgedbSettings/1.0.0/pvplugins-bridgedbSettings-1.0.0.jar";
    sha256 = "0gq5ybdv4ci5k01vr80ixlji463l9mdqmkjvhb753dbxhhcnxzjy";
  };

  javaPath = "${jdk.jre}/bin/java";

  libPath0 = "../lib";
  libPath1 = "$out/lib/pathvisio";

  modulesPath0 = "../modules";
  modulesPath1 = "${libPath1}/modules";

  sharePath1 = "$out/share/pathvisio";

  installPathVisioExecutable = ''
    cat > $out/bin/pathvisio <<EOF
#! $shell
mkdir -p "\$HOME/.PathVisio/.bundles"
PREFS_FILE="\$HOME/.PathVisio/.PathVisio"
if [ ! -e "\$PREFS_FILE" ];
then
  echo "#" > "\$PREFS_FILE";
  echo "#Wed Jun 27 16:21:04 PDT 2018" >> "\$PREFS_FILE";
fi

if [ ! -e "\$HOME/.PathVisio/.bundles/pvplugins-bridgedbSettings-1.0.0.jar" ];
then
  ln -s "${bridgedbSettings}" "\$HOME/.PathVisio/.bundles/pvplugins-bridgedbSettings-1.0.0.jar"
  cat ${pathvisioPlugins} > "\$HOME/.PathVisio/.bundles/pathvisio.xml"
  sed -i.bak "s#HOME_REPLACE_ME#\$HOME#g" "\$HOME/.PathVisio/.bundles/pathvisio.xml"
fi

# TODO: watch this issue:
# https://github.com/PathVisio/pathvisio/issues/97
# and when --help and --version are supported,
# update here (but note that the following regex
# is probably not quite correct):
#info_re='\\-h|\\-v|\\-\\-help|\\-\\-version'
info_re='\\-h|\\-v'
if [[ "\$1" =~ \$info_re ]];
then
  ${javaPath} -jar -Dfile.encoding=UTF-8 ${sharePath1}/pathvisio.jar \$1
  exit 0
fi
'' + concatStringsSep "" (map (d: d.linkCmd) datasources) + ''

target_file_raw=\$(echo "\$@" | sed "s#.*\\ \\([^\\ ]*\\.gpml\\(\\.xml\\)\\{0,1\\}\\)#\\1#")

if [ ! "\$target_file_raw" ];
then
  # We don't want to overwrite an existing file.
  suffix=\$(date -j -f "%a %b %d %T %Z %Y" "\$(date)" "+%s")
  target_file_raw="./pathway-\$suffix.gpml"
fi

target_file=\$("${coreutils}/bin/readlink" -f "\$target_file_raw")

patchedFlags=""

# If no target file specified, or if it is specified but doesn't exist,
# we create a starter file and open that.
if [ ! -e "\$target_file" ];
then
        echo "Opening new file: \$target_file"
        cat "${pathwayStub}" > "\$target_file"
        chmod u+rw "\$target_file"
        sed -i.bak "s#Homo sapiens#${organism}#" "\$target_file"
        rm "\$target_file.bak"
        patchedFlags="\$@ \$target_file"
else
        echo "Opening specified file: \$target_file"
        patchedFlags=\$(echo "\$@" | sed "s#\$target_file_raw#\$target_file#")
fi

# TODO how should we handle the case of opening a GPML file having
# a species not matching organism specified above?

current_organism="${organism}"
# TODO when, if ever, do we want to use the "-x" flag?
if [ ! \$(grep -Fq "${organism}" \$target_file) ];
then
  current_organism=\$(grep -o 'Organism="\\(.*\\)"' \$target_file | sed 's#.*"\\(.*\\)".*#\\1#')
fi

# TODO verify that if a local gene or metabolite db is specified, it's used
# even if we have the webservice running for the other.
if ! grep -q "^BRIDGEDB_CONNECTION.*\$current_organism" "\$PREFS_FILE";
then
  echo "Setting BRIDGEDB_CONNECTION_1 for \$current_organism"
  sed -i.bak "/^BRIDGEDB_CONNECTION_.*$/d" "\$PREFS_FILE"
  rm "\$PREFS_FILE.bak"
  echo "BRIDGEDB_CONNECTION_1=idmapper-bridgerest\\:http\\://webservice.bridgedb.org\\:80/\$current_organism" >> "\$PREFS_FILE"
fi

# NOTE: using nohup ... & to keep GUI running, even if the terminal is closed
nohup ${javaPath} -jar -Dfile.encoding=UTF-8 "${sharePath1}/pathvisio.jar" \$patchedFlags &
EOF

    chmod a+x $out/bin/pathvisio

    mkdir -p "${sharePath1}"
    cp ./pathvisio.jar "${sharePath1}/pathvisio.jar"
  '';

  src = fetchFromGitHub {
    owner = "pathvisio";
    repo = "PathVisio";
    rev = "61f15de96b676ee581858f0485f9c6d8f61a3476";
    #sha256 = "1n2897290g6kph1l04d2lj6n7137w0gnavzp9rjz43hi1ggyw6f9";
    sha256 = "0qng251kz1mj8pff9mhrngz836ihmpdh7577xipg62dx0yklz5ql";
    stripRoot = false;
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
    substituteInPlace ./JavaApplicationStub \
          --replace "JAVACMD=\"JAVACMD_REPLACE_ME\"" "JAVACMD=\"${javaPath}\""
  '';

  buildPhase = (if ! desktop then ''
    ant
  '' else if stdenv.system == "x86_64-darwin" then ''
    ant appbundler
  '' else ''
    ant exe
  '') + ''

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
    echo 'Desktop functionality not enabled.'
  '' else ''
    ${installPathVisioExecutable}
  '' + (
    if stdenv.system == "x86_64-darwin" then ''
      mkdir -p "$out/Applications"
      unzip -o release/${baseName}.app.zip -d "$out/Applications/"
      cp ./JavaApplicationStub $out/Applications/PathVisio.app/Contents/MacOS/JavaApplicationStub
    '' else ''
      mkdir -p "$out/share/applications"
      ln -s ${desktopItem}/share/applications/* "$out/share/applications/"
    ''
  ));

  meta = with stdenv.lib;
    { description = "A tool to edit and analyze biological pathways";
      longDescription = ''
        You can specify a species:
        nix-env -iA nixos.pathvisio --arg organism "Mus musculus"

        The available species are listed here:
        https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/resources/org/bridgedb/bio/organisms.txt

        You can also specify whether to use a local datasource or the BridgeDb webservice:
        nix-env -iA nixos.pathvisio --arg organism "Homo sapiens" --arg genes "webservice" --arg interactions local --arg metabolites "webservice"
      '';
      homepage = https://www.pathvisio.org/;
      license = licenses.asl20;
      maintainers = with maintainers; [ ariutta ];
      platforms = platforms.all;
    };
}
