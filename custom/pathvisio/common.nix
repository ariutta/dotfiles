{ ant,
callPackage,
coreutils,
fetchFromGitHub,
fetchurl,
getopt,
jdk,
makeDesktopItem,
stdenv,
unzip,
xmlstarlet,
headless ? false,
organism ? "Homo sapiens",
datasources ? [],
memory ? "1024m" }:
# TODO allow for specifying plugins to install

with builtins;

let
  baseName = "PathVisio";
  version = "3.3.0";
  sensible-jvm-opts = callPackage ./sensible-jvm-opts.nix {}; 
in
stdenv.mkDerivation rec {
  name = replaceStrings [" "] ["_"] (concatStringsSep "-" (filter (x: isString x) [baseName version organism]));

  # TODO: should this be nativeBuildInputs or just buildInputs?
  # TODO: I initially assumed these were on the PATH even after
  #       building, but they are not, so it might make sense to
  #       remove some of these from nativeBuildInputs/buildInputs.
  nativeBuildInputs = [ unzip ant jdk sensible-jvm-opts xmlstarlet ];
  buildInputs = [ coreutils sensible-jvm-opts ] ++ map (d: d.src) datasources;

  # aliases for command-line tool binaries
  # that we keep using in production (after
  # the initial unpack/build/install phase).
  # NOTE: not aliasing the following:
  # echo, eval, exit, shift
  getoptAlias = "${getopt}/bin/getopt";
  javaAlias = "${jdk.jre}/bin/java";
  xmlstarletAlias = "${xmlstarlet}/bin/xmlstarlet";

  bridgedbSettings = fetchurl {
    url = "http://repository.pathvisio.org/plugins/pvplugins-bridgedbSettings/1.0.0/pvplugins-bridgedbSettings-1.0.0.jar";
    sha256 = "0gq5ybdv4ci5k01vr80ixlji463l9mdqmkjvhb753dbxhhcnxzjy";
  };

  pathvisioPluginsXML = ./pathvisio.xml;
  pathwayStub = ./pathway.gpml;
  #sums = "./sums/*";
  sums = ./sums;

  XSLT_NORMALIZE = ./normalize.xslt;
  WP4321_98000_BASE64 = fetchurl {
    name = "WP4321_98000.gpml.base64";
    url = "http://webservice.wikipathways.org/getPathwayAs?fileType=gpml&pwId=WP4321&revision=98000";
    sha256 = "0hxd03ni5ws6n219bz5wrs0lv0clk0qnrigz3qwrqbna54vi3n6m";
  };
  WP4321_98055_BASE64 = fetchurl {
    name = "WP4321_98055.gpml.base64";
    url = "http://webservice.wikipathways.org/getPathwayAs?fileType=gpml&pwId=WP4321&revision=98055";
    sha256 = "0d4r54hkl4fcvl85s7c1q844rbjwlg99x66l7hhr00ppb5xr17v0";
  };
  WP1243_69897 = fetchurl {
    url = "https://raw.githubusercontent.com/PathVisio/GPML/fa76a73db631bdffcf0f63151b752e0e0357fd26/test/2013a/WP1243_69897.gpml";
    sha256 = "0nxrf0rkhqlljdjfallmkb9vn0siwdmxh6gys8r5lldf1az1wq9q";
  };
  WP1243_69897_BPSS_SHASUM = ./WP1243_69897.bpss.shasum;
  WP1243_69897_OWL = ./WP1243_69897.owl;
  WP1243_69897_OWL_SHASUM = ./WP1243_69897.owl.shasum;
  WP1243_69897_PNG_SHASUM = ./WP1243_69897.png.shasum;

  libPath0 = "../lib";
  libPath1 = "$out/lib/pathvisio";

  modulesPath0 = "../modules";
  modulesPath1 = "${libPath1}/modules";

  sharePath1 = "$out/share/pathvisio";

  biopax3GPMLSrc = fetchurl {
    url = "https://cdn.rawgit.com/wikipathways/wikipathways.org/e8fae01e/wpi/bin/Biopax3GPML.jar";
    sha256 = "1jm5khh6n78fghd7wp0m5dcb6s2zp23pgsbw56rpajfxgx1sz7lg";
  };

  converterClasses = [
    "${modulesPath0}/org.pathvisio.core.jar"
    "${libPath0}/com.springsource.org.jdom-1.1.0.jar"
    "${libPath0}/org.bridgedb.jar"
    "${libPath0}/org.bridgedb.bio.jar"
    "${libPath0}/org.apache.batik.bridge_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.css_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.dom_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.dom.svg_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.ext.awt_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.extension_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.parser_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.svggen_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.transcoder_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.util_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.util.gui_1.7.0.v200903091627.jar"
    "${libPath0}/org.apache.batik.xml_1.7.0.v201011041433.jar"
    "${libPath0}/org.pathvisio.pdftranscoder.jar"
    "${libPath0}/org.w3c.css.sac_1.3.1.v200903091627.jar"
    "${libPath0}/org.w3c.dom.events_3.0.0.draft20060413_v201105210656.jar"
    "${libPath0}/org.w3c.dom.smil_1.0.1.v200903091627.jar"
    "${libPath0}/org.w3c.dom.svg_1.1.0.v201011041433.jar"
    biopax3GPMLSrc
  ];
  differClasses = [
    "${modulesPath0}/org.pathvisio.core.jar"
    "${libPath0}/com.springsource.org.jdom-1.1.0.jar"
    "${libPath0}/org.bridgedb.jar"
    "${libPath0}/org.bridgedb.bio.jar"
  ];
  patcherClasses = [
    "${modulesPath0}/org.pathvisio.core.jar"
    "${libPath0}/com.springsource.org.jdom-1.1.0.jar"
    "${libPath0}/org.bridgedb.jar"
    "${libPath0}/org.bridgedb.bio.jar"
  ];

  # TODO: gui launcher classes vs. jar?
  guiClasses = [
    "${modulesPath0}/org.pathvisio.core.jar"
    "${modulesPath0}/org.pathvisio.launcher.jar"
    "${libPath0}/com.springsource.org.jdom-1.1.0.jar"
    "${libPath0}/org.bridgedb.jar"
    "${libPath0}/org.bridgedb.bio.jar"
    "${libPath0}/org.apache.batik.bridge_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.css_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.dom_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.dom.svg_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.ext.awt_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.extension_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.parser_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.svggen_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.transcoder_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.util_1.7.0.v201011041433.jar"
    "${libPath0}/org.apache.batik.util.gui_1.7.0.v200903091627.jar"
    "${libPath0}/org.apache.batik.xml_1.7.0.v201011041433.jar"
    "${libPath0}/org.pathvisio.pdftranscoder.jar"
    "${libPath0}/org.w3c.css.sac_1.3.1.v200903091627.jar"
    "${libPath0}/org.w3c.dom.events_3.0.0.draft20060413_v201105210656.jar"
    "${libPath0}/org.w3c.dom.smil_1.0.1.v200903091627.jar"
    "${libPath0}/org.w3c.dom.svg_1.1.0.v201011041433.jar"
    biopax3GPMLSrc
  ];

  converterCLASSPATH = concatStringsSep ":" (converterClasses);
  differCLASSPATH = concatStringsSep ":" (differClasses);
  patcherCLASSPATH = concatStringsSep ":" (patcherClasses);

  guiCLASSPATH = concatStringsSep ":" (guiClasses);

  src = fetchFromGitHub {
    owner = "PathVisio";
    repo = "pathvisio";
    rev = "61f15de96b676ee581858f0485f9c6d8f61a3476";
    sha256 = "1n2897290g6kph1l04d2lj6n7137w0gnavzp9rjz43hi1ggyw6f9";
  };

  pngIconSrc = "${src}/www/bigcateye_135x135.png";

  iconSrc = "${src}/lib-build/bigcateye.icns";

  buildPhase = (if headless then ''
    ant
  '' else if stdenv.system == "x86_64-darwin" then ''
    ant appbundler
  '' else ''
    ant exe
  '') + ''
    mkdir -p ./bin
    cd ./bin

    converter_java_opts=$(sensible-jvm-opts "${converterCLASSPATH}" "${memory}")
    differ_java_opts=$(sensible-jvm-opts "${differCLASSPATH}" "${memory}")
    gui_java_opts=$(sensible-jvm-opts "${guiCLASSPATH}" "${memory}")
    patcher_java_opts=$(sensible-jvm-opts "${patcherCLASSPATH}" "${memory}")

    cd ./..

    cat > ./bin/pathvisio <<EOF
#! $shell
SUBCOMMAND=""

if [[ "\$1" =~ ^(convert|diff|patch|launch)$ ]]; then
  SUBCOMMAND="\$1"
  shift
elif [[ "\$1" =~ ^(\-.*)$ ]]; then
  SUBCOMMAND=false
else
  echo "Invalid subcommand \$1" >&2
  exit 1
fi

TOP_OPTS=\$("${getoptAlias}" -o hvX: --long help,version:,icon: \
             -n 'pathvisio' -- "\$@")

if [ \$? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# NOTE: keep the quotes
eval set -- "\$TOP_OPTS"

HELP=false
VERSION=false
JAVA_CUSTOM_OPTS_ARR=()
ICON=
while true; do
  case "\$1" in
    -h | --help ) HELP=true; shift ;;
    -v | --version ) VERSION=true; shift ;;
    -X ) JAVA_CUSTOM_OPTS_ARR+=("-X\$2"); shift 2 ;;
    --icon ) ICON="\$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

# TODO
JAVA_CUSTOM_OPTS=\$(IFS=" " ; echo "\$\{JAVA_CUSTOM_OPTS_ARR[*]\}")

if [ \$VERSION == true ]; then
  ${javaAlias} -jar -Dfile.encoding=UTF-8 ${sharePath1}/pathvisio.jar -v
  exit 0
elif [ \$SUBCOMMAND == false ] && [ \$HELP == true ]; then
  echo 'usage: pathvisio [--version] [--help] [<command> <args>]'
  echo 'commands: convert, diff, patch, launch'
  exit 0
elif [ \$SUBCOMMAND = 'convert' ]; then
  if [ \$HELP == true ]; then
    echo 'usage: pathvisio convert <input> <output>'
    echo ' '
    echo 'examples on example data WP1243_69897.gpml:'
    echo '    wget https://cdn.rawgit.com/PathVisio/GPML/fa76a73d/test/2013a/WP1243_69897.gpml'
    echo ' '
    echo '  # GPML -> BioPAX/OWL'
    echo '  pathvisio convert WP1243_69897.gpml WP1243_69897.owl'
    echo '  # GPML -> PDF'
    echo '  pathvisio convert WP1243_69897.gpml WP1243_69897.pdf'
    echo '  # GPML -> PNG'
    echo '  pathvisio convert WP1243_69897.gpml WP1243_69897.png'
    exit 0
  fi

  CLASSPATH="${converterCLASSPATH}"
  ${javaAlias} $converter_java_opts -ea -classpath \$CLASSPATH org.pathvisio.core.util.Converter "\$@"
  exit 0
elif [ \$SUBCOMMAND = 'diff' ]; then
  if [ \$HELP == true ]; then
    echo 'usage: pathvisio diff <input1> <input2>'
    echo ' '
    echo 'example (get data as described in pathvisio convert -h):'
    echo "  sed 's/Color=\\".*\\"/Color=\\"ff0000\\"/g' WP1243_69897.gpml > test.gpml"
    echo ' '
    echo '  pathvisio diff WP1243_69897.gpml test.gpml > test.patch'
    exit 0
  fi

  CLASSPATH="${differCLASSPATH}"
  ${javaAlias} $differ_java_opts -ea -classpath \$CLASSPATH org.pathvisio.core.gpmldiff.GpmlDiff "\$@"
  exit 0
elif [ \$SUBCOMMAND = 'patch' ]; then
  if [ \$HELP == true ]; then
    echo 'usage: pathvisio patch <reference> < <patch>'
    echo ' '
    echo 'example (create patch file as described in pathvisio diff -h)'
    echo ' '
    echo '  pathvisio patch WP1243_69897.gpml < test.patch'
    exit 0
  fi

  CLASSPATH="${patcherCLASSPATH}"
  ${javaAlias} $patcher_java_opts -ea -classpath \$CLASSPATH org.pathvisio.core.gpmldiff.PatchMain "\$@"
  exit 0
elif [ \$SUBCOMMAND = 'launch' ]; then
  # TODO: close this issue:
  # https://github.com/PathVisio/pathvisio/issues/97
  if [ \$HELP == true ];
  then
    ${javaAlias} -jar -Dfile.encoding=UTF-8 ${sharePath1}/pathvisio.jar -h | sed 's/pathvisio/pathvisio launch/'
    exit 0
  fi

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
    cat ${pathvisioPluginsXML} | ${xmlstarletAlias} ed -u '/ns2:pvRepository/url' -v "$HOME/.PathVisio/.bundles" > "\$HOME/.PathVisio/.bundles/pathvisio.xml"
  fi
  '' + concatStringsSep "" (map (d: d.linkCmd) datasources) + ''

  target_file_raw=\$(echo "\$@" | sed "s#.*\\ \\([^\\ ]*\\.gpml\\(\\.xml\\)\\{0,1\\}\\)#\\1#")

  if [ ! "\$target_file_raw" ];
  then
    # We don't want to overwrite an existing file.
    suffix=\$(date -j -f "%a %b %d %T %Z %Y" "\$(date)" "+%s")
    target_dir="."
    if [ ! -w "\$target_dir/" ]; then
      target_dir="\$HOME"
    fi
    target_file_raw="\$target_dir/pathway-\$suffix.gpml"
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
          # TODO: should we use xmlstarlet here instead of sed?
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
    # TODO: should we use xmlstarlet here instead of sed?
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

  # TODO: will the CFProcessPath export or the -Xdock flags
  #   mess up the Linux desktop app builder?
  # TODO: there are probably other settings/options from Info.plist
  #   https://github.com/PathVisio/pathvisio/blob/master/Info.plist
  #   that should be used for Darwin. Should we modify JavaApplicationStub
  #   to work with this pathvisio script, or should we move content from
  #   Info.plist into here?

  # enable drag&drop to the dock icon
  export CFProcessPath="$0"

#  # NOTE: using nohup ... & to keep GUI running, even if the terminal is closed
#  nohup ${javaAlias} $gui_java_opts \
#    -Xdock:icon="${iconSrc}" \
#    -Xdock:name="${name}" \
#    -jar "${sharePath1}/pathvisio.jar" \$patchedFlags &
else
  echo "Invalid subcommand \$1" >&2
  exit 1
fi
EOF
    chmod a+x ./bin/pathvisio
  '';

  doCheck = true;

  checkPhase = ''
    # TODO: Should we be running existing tests like these for the built versions:
    # https://github.com/PathVisio/pathvisio/tree/master/modules/org.pathvisio.core/test/org/pathvisio/core

    mkdir ./test-results

    cd ./bin

    cat ${WP4321_98000_BASE64} | xmlstarlet sel -t -v '//ns1:data' | base64 -d - > WP4321_98000.gpml
    cat ${WP4321_98055_BASE64} | xmlstarlet sel -t -v '//ns1:data' | base64 -d - > WP4321_98055.gpml

    echo "convert"
    #for f in ../{example-data/,testData/,testData/2010a/{biopax,parsetest}}*.gpml; do
    for f in $(ls -1 ../{example-data/,testData/,testData/2010a/{biopax,parsetest}}*.gpml | head -n 2) ; do
      converted_f="../test-results/"$(basename "$f" ".gpml")

      # convert/update from old GPML schema to latest:
      ./pathvisio convert "$f" "$converted_f".gpml
      xmlstarlet tr ${XSLT_NORMALIZE} "$converted_f".gpml > "$converted_f".norm.gpml

      ./pathvisio convert "$converted_f".gpml "$converted_f".owl
      xmlstarlet tr ${XSLT_NORMALIZE} "$converted_f".owl > "$converted_f".norm.owl
      cp "$converted_f".bpss "$converted_f".norm.bpss

      ./pathvisio convert "$converted_f".gpml "$converted_f".png
      ./pathvisio convert "$converted_f".gpml "$converted_f".pdf
    done

    cp ${sums}/* "../test-results"

    for f in ../test-results/*.norm.{gpml,owl,bpss}.shasum; do
      sha256sum -c "$f"
    done
    for f in ../test-results/*.{pdf,png}.sizesum; do
      converted="../test-results/"$(basename "$f" ".sizesum")
      actual=$(stat --printf="%s" "$converted")
      expected=$(cat "$f")
      if [[ "$actual" != "$expected" ]]; then
        echo "Error: pathvisio convert test failed."
        echo "       Unequal sizes for $converted:"
        echo "       expected: $expected"
        echo "       actual: $actual"
        exit 1;
      fi
    done

    ./pathvisio convert ${WP1243_69897} ./WP1243_69897.owl
    xmlstarlet tr ${XSLT_NORMALIZE} WP1243_69897.owl > WP1243_69897.owl.norm
    mv WP1243_69897.owl.norm WP1243_69897.owl
    cp ${WP1243_69897_BPSS_SHASUM} ./WP1243_69897.bpss.shasum
    cp ${WP1243_69897_OWL_SHASUM} ./WP1243_69897.owl.shasum
    sha256sum -c WP1243_69897.bpss.shasum
    sha256sum -c WP1243_69897.owl.shasum
    rm WP1243_69897.owl WP1243_69897.owl.shasum WP1243_69897.bpss WP1243_69897.bpss.shasum

    ./pathvisio convert ${WP1243_69897} ./WP1243_69897.png
    cp ${WP1243_69897_PNG_SHASUM} ./WP1243_69897.png.shasum
    # TODO why does the sha256sum differ between Linux and Darwin?
    #sha256sum -c WP1243_69897.png.shasum
    rm WP1243_69897.png WP1243_69897.png.shasum

    ./pathvisio convert ${WP1243_69897} WP1243_69897.pdf
    # NOTE: PDF conversion produces a different output every time,
    # so we can't use shasum to verify.
    rm WP1243_69897.pdf

    echo "diff"
    ./pathvisio diff WP4321_98000.gpml WP4321_98055.gpml > WP4321_98000_98055.patch

    echo "patch"
    cp WP4321_98000.gpml WP4321_98055.roundtrip.gpml
    ./pathvisio patch WP4321_98055.roundtrip.gpml < WP4321_98000_98055.patch

    # TODO pathvisio patch doesn't fully patch the diff between WP4321_98000 and
    # WP4321_98055, so we're forced to use the kludge of comparing just the
    # element structure instead of the actual output.
#    xmlstarlet tr ${XSLT_NORMALIZE} WP4321_98055.gpml > WP4321_98055.norm.gpml
#    xmlstarlet tr ${XSLT_NORMALIZE} WP4321_98055.roundtrip.gpml > WP4321_98055.roundtrip.norm.gpml
    xmlstarlet tr ${XSLT_NORMALIZE} WP4321_98055.gpml | xmlstarlet el > WP4321_98055.norm.gpml
    xmlstarlet tr ${XSLT_NORMALIZE} WP4321_98055.roundtrip.gpml | xmlstarlet el > WP4321_98055.roundtrip.norm.gpml
    common=$(comm -3 --nocheck-order WP4321_98055.norm.gpml WP4321_98055.roundtrip.norm.gpml)
    if [[ "$common" != "" ]]; then
      echo "Error: pathvisio patch test failed. Mis-matched content:"
      echo "-----------------"
      echo "$common"
      echo "-----------------"
      exit 1;
    fi
    rm WP4321_98055.norm.gpml WP4321_98055.roundtrip.norm.gpml
    rm WP4321_98000_98055.patch WP4321_98000.gpml WP4321_98055.gpml

    cd ../
  '';

  desktopItem = makeDesktopItem {
    name = name;
    exec = "pathvisio launch";
    #exec = "pathvisio launch ~/pathway-\$(${date} -j -f \"%a %b %d %T %Z %Y\" \"\$(${date})\" \"+%s\").gpml";
    #exec = "pathvisio launch ~/pathway-test.gpml";
    icon = "${pngIconSrc}";
    desktopName = baseName;
    genericName = "Pathway Editor";
    comment = meta.description;
    # See https://specifications.freedesktop.org/menu-spec/latest/apa.html
    categories = "Editor;Science;Biology;DataVisualization;";
    mimeType = "application/gpml+xml";
    # TODO what is the terminal option?
    terminal = "false";
  };

  # TODO Should we somehow take advantage of the osgi and apache capabilities?
  installPhase = ''
    mkdir -p "$out/bin" "${libPath1}" "${modulesPath1}"

    # Enable this to reset the test-result sums
    mkdir -p "$out/test-results"
    cp -r ./test-results/*.{bpss,gpml,pdf,png,owl} "$out/test-results/"
    here="$(pwd)"
    cd "$out/test-results/"
    echo "coreutils: ${coreutils}"
    for f in $out/test-results/*.{bpss,gpml,pdf,png,owl}; do
      echo "generating sha256sum for $f"
      base=$(basename "$f")
      echo "base: $base"
      sha256sum --tag "$base" > "$base".shasum
      stat --printf="%s" "$f" > "$base".sizesum
    done
    #sudo rm ./sums/*
    #cp ./result/test-results/*.norm.{bpss,gpml,owl}.shasum sums/
    #cp ./result/test-results/*.{pdf,png}.sizesum sums/

    cd "$here"

    cp -r ./bin/* $out/bin/
    for f in $out/bin/*; do
      substituteInPlace $f \
            --replace "${libPath0}" "${libPath1}" \
            --replace "${modulesPath0}" "${modulesPath1}"
    done

    cp -r ./lib/* "${libPath1}/"
    cp -r ./modules/* "${modulesPath1}/"
  '' + (
  if headless then ''
    echo 'Desktop functionality not enabled.'
  '' else ''
    mkdir -p "${sharePath1}"
    cp ./pathvisio.jar "${sharePath1}/pathvisio.jar"
  '' + (
    if stdenv.system == "x86_64-darwin" then ''
      mkdir -p "$out/Applications"
      unzip -o release/${baseName}.app.zip -d "$out/Applications/"

      # TODO develop a good script for this. I can do one of two options:

#      # 1. use semi-generic JavaApplicationStub
#      substituteInPlace ./JavaApplicationStub \
#            --replace "JAVACMD=\"JAVACMD_REPLACE_ME\"" "JAVACMD=\"${javaAlias}\""
#      cp ./JavaApplicationStub $out/Applications/PathVisio.app/Contents/MacOS/JavaApplicationStub

      # 2. use my own pathvisio script
      cp $out/bin/pathvisio $out/Applications/PathVisio.app/Contents/MacOS/pathvisio
      substituteInPlace $out/Applications/PathVisio.app/Contents/Info.plist \
            --replace "JavaApplicationStub" "pathvisio launch"
    '' else ''
      mkdir -p "$out/share/applications"
      ln -s ${desktopItem}/share/applications/* "$out/share/applications/"
    ''
  ));

  meta = with stdenv.lib;
    { description = "A tool to create, edit and analyze biological pathways";
      longDescription = ''
        There are several options you can specify:

        * organism: the species to automatically use for new pathways (default: "Homo sapiens")
        nix-env -iA nixos.pathvisio --arg organism "Mus musculus"

        The available species are listed here:
        https://github.com/bridgedb/BridgeDb/blob/master/org.bridgedb.bio/resources/org/bridgedb/bio/organisms.txt

        * genes, interactions, metabolites: use local datasource or BridgeDb webservice (default: webservice for genes and metabolites; local for interactions)
        nix-env -iA nixos.pathvisio --arg genes "local" --arg interactions "local" --arg metabolites "local"

        * headless: CLI only (default: false)
        nix-env -iA nixos.pathvisio --arg headless true

        * Any combination of the above
        nix-env -iA nixos.pathvisio --arg organism "Mus musculus" --arg headless true --arg genes "local" --arg interactions "local"
      '';
      homepage = https://www.pathvisio.org/;
      # download_page = https://www.pathvisio.org/downloads/installation/
      # homebrew/science formula (deprecated):
      # https://github.com/Homebrew/homebrew-science/blob/51e1e3b106ced03b0e4056ef3f81d6a8729e3298/pathvisio.rb
      # brewsci/homebrew-bio formula:
      # https://github.com/brewsci/homebrew-bio/blob/master/Formula/pathvisio.rb
      license = licenses.asl20;
      maintainers = with maintainers; [ ariutta ];
      platforms = platforms.all;
    };
}
