{ ant,
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
  custom = import ../all-custom.nix;
  java-buildpack-memory-calculator = custom.java-buildpack-memory-calculator;
in
stdenv.mkDerivation rec {
  name = replaceStrings [" "] ["_"] (concatStringsSep "-" (filter (x: isString x) [baseName version organism]));

  # should this be nativeBuildInputs or just buildInputs?
  nativeBuildInputs = [ unzip ant jdk xmlstarlet ];
  buildInputs = map (d: d.src) datasources;

  bridgedbSettings = fetchurl {
    url = "http://repository.pathvisio.org/plugins/pvplugins-bridgedbSettings/1.0.0/pvplugins-bridgedbSettings-1.0.0.jar";
    sha256 = "0gq5ybdv4ci5k01vr80ixlji463l9mdqmkjvhb753dbxhhcnxzjy";
  };

  pathvisioPlugins = ./pathvisio.xml;
  pathwayStub = ./pathway.gpml;

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

  javaPath = "${jdk.jre}/bin/java";

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

  installPathVisioGUILauncher = ''
    cat > $out/bin/pathvisio <<EOF
#! $shell
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

# GUI launcher section
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
  # TODO: should we use xmlstarlet here instead of sed?
  sed -i.bak "s#HOME_REPLACE_ME#\$HOME#g" "\$HOME/.PathVisio/.bundles/pathvisio.xml"
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

# NOTE: using nohup ... & to keep GUI running, even if the terminal is closed
nohup ${javaPath} \
  -Xdock:icon="${iconSrc}" \
  -Xdock:name="${name}" \
  -Xmx${memory}
  -jar -Dfile.encoding=UTF-8 \
  "${sharePath1}/pathvisio.jar" \$patchedFlags &
EOF
    chmod a+x $out/bin/pathvisio

    mkdir -p "${sharePath1}"
    cp ./pathvisio.jar "${sharePath1}/pathvisio.jar"
  '';

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

# see these refs:
# https://docs.oracle.com/cd/E13150_01/jrockit_jvm/jrockit/jrdocs/refman/optionX.html
# https://medium.com/@matt_rasband/dockerizing-a-spring-boot-application-6ec9b9b41faf
get_java_opts () {
  CLASSPATH=$1
  VM_OPTS=$2

  APPLICATION_SIZE_ON_DISK_IN_MB=`${coreutils}/bin/du -cm $(echo $CLASSPATH | tr ':' ' ') | tail -1 | cut -f1`
  loaded_classes=$(${coreutils}/bin/expr "400" "*" "$APPLICATION_SIZE_ON_DISK_IN_MB")
  stack_threads=$(${coreutils}/bin/expr "15" "+" "$APPLICATION_SIZE_ON_DISK_IN_MB" "*" "6" "/" "10")

  java_opts_calc=`${java-buildpack-memory-calculator}/bin/java-buildpack-memory-calculator \
          -loadedClasses $loaded_classes \
          -poolType metaspace \
          -stackThreads $stack_threads \
          -totMemory ${memory} \
          -vmOptions "$VM_OPTS"`

  echo "$java_opts_calc -Dfile.encoding=UTF-8"
}

    converter_java_opts=$(get_java_opts "${converterCLASSPATH}")
    differ_java_opts=$(get_java_opts "${differCLASSPATH}")
    patcher_java_opts=$(get_java_opts "${patcherCLASSPATH}")

    gui_java_opts=$(get_java_opts "${guiCLASSPATH}")

    cd ./..

    cat > ./bin/gpmlconvert <<EOF
#! $shell
CLASSPATH=${converterCLASSPATH}
${javaPath} $converter_java_opts -ea -classpath \$CLASSPATH org.pathvisio.core.util.Converter "\$@"
EOF

    cat > ./bin/gpmldiff <<EOF
#! $shell
CLASSPATH=${differCLASSPATH}
${javaPath} $differ_java_opts -ea -classpath \$CLASSPATH org.pathvisio.core.gpmldiff.GpmlDiff "\$@"
EOF

    cat > ./bin/gpmlpatch <<EOF
#! $shell
CLASSPATH=${patcherCLASSPATH}
${javaPath} $patcher_java_opts -ea -classpath \$CLASSPATH org.pathvisio.core.gpmldiff.PatchMain "\$@"
EOF

    chmod a+x ./bin/gpmlconvert
    chmod a+x ./bin/gpmldiff
    chmod a+x ./bin/gpmlpatch

    cat > ./bin/pvjava <<EOF
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

OPTS1=\$("${getopt}/bin/getopt" -o hX: --long help:,icon: \
             -n 'pvjava' -- "\$@")

if [ \$? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

# Note the quotes around \$OPTS1: they are essential!
eval set -- "\$OPTS1"

HELP=false
JAVA_CUSTOM_OPTS_ARR=()
ICON=
while true; do
  case "\$1" in
    -h | --help ) HELP=true; shift ;;
    -X ) JAVA_CUSTOM_OPTS_ARR+=("-X\$2"); shift 2 ;;
    --icon ) ICON="\$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

#echo "OPTS1"
#echo "\$OPTS1"
#echo "HELP: \$HELP"
#echo "SUBCOMMAND: \$SUBCOMMAND"

JAVA_CUSTOM_OPTS=\$(IFS=" " ; echo "\$\{JAVA_CUSTOM_OPTS_ARR[*]\}")

if [ \$SUBCOMMAND == false ] && [ \$HELP == true ]; then
  echo 'some help'
  exit 0
elif [ \$SUBCOMMAND = 'convert' ]; then
  CLASSPATH="${converterCLASSPATH}"
  ${javaPath} $converter_java_opts -ea -classpath \$CLASSPATH org.pathvisio.core.util.Converter "\$@"
  exit 0
elif [ \$SUBCOMMAND = 'diff' ]; then
  CLASSPATH="${differCLASSPATH}"
  ${javaPath} $differ_java_opts -ea -classpath \$CLASSPATH org.pathvisio.core.gpmldiff.GpmlDiff "\$@"
  exit 0
elif [ \$SUBCOMMAND = 'patch' ]; then
  CLASSPATH="${patcherCLASSPATH}"
  ${javaPath} $patcher_java_opts -ea -classpath \$CLASSPATH org.pathvisio.core.gpmldiff.PatchMain "\$@"
  exit 0
elif [ \$SUBCOMMAND = 'launch' ]; then
  echo 'Launching...'

  echo '$1'
  echo "\$1"

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

  # GUI launcher section
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
    # TODO: should we use xmlstarlet here instead of sed?
    sed -i.bak "s#HOME_REPLACE_ME#\$HOME#g" "\$HOME/.PathVisio/.bundles/pathvisio.xml"
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

  # NOTE: using nohup ... & to keep GUI running, even if the terminal is closed
  nohup ${javaPath} $gui_java_opts \
    -Xdock:icon="${iconSrc}" \
    -Xdock:name="${name}" \
    -jar "${sharePath1}/pathvisio.jar" \$patchedFlags &



















  #echo "launch it: nohup ${javaPath} \$JAVA_CUSTOM_OPTS -jar pathvisio.jar &"
#  # NOTE: using nohup ... & to keep GUI running, even if the terminal is closed
#  nohup ${javaPath} $gui_java_opts \
#    -Xdock:icon="${iconSrc}" \
#    -Xdock:name="${name}" \
#    -jar "${sharePath1}/pathvisio.jar" "\$@" &

  #nohup ${javaPath} \$JAVA_CUSTOM_OPTS -jar pathvisio.jar &
  #CLASSPATH="${guiCLASSPATH}"
  #${javaPath} $gui_java_opts -ea -classpath \$CLASSPATH org.pathvisio.launcher.PathVisioMain "\$@"
  #${javaPath} $gui_java_opts -ea -classpath \$CLASSPATH org.pathvisio.launcher.PathVisioMain "\$@"
  #exit 0
else
  echo "Invalid subcommand \$1" >&2
  exit 1
fi
EOF
    chmod a+x ./bin/pvjava
  '';

  doCheck = true;

  checkPhase = ''
    # TODO are we running the existing tests?
    cd ./bin

    # TODO: should we use xmlstarlet here instead of sed?
    cat ${WP4321_98000_BASE64} | sed -n 2p | sed -E "s#.*<ns1:data>(.+)</ns1:data>.*#\1#g" | base64 -d - > WP4321_98000.gpml
    cat ${WP4321_98055_BASE64} | sed -n 2p | sed -E "s#.*<ns1:data>(.+)</ns1:data>.*#\1#g" | base64 -d - > WP4321_98055.gpml
    ./gpmldiff WP4321_98000.gpml WP4321_98055.gpml > WP4321_98000_98055.patch
    cp WP4321_98000.gpml WP4321_98055.roundtrip.gpml
    ./gpmlpatch WP4321_98055.roundtrip.gpml < WP4321_98000_98055.patch

#    # TODO gpmlpatch doesn't fully patch the diff between these two:
#    xmlstarlet tr ${XSLT_NORMALIZE} WP4321_98055.gpml > WP4321_98055.norm.gpml
#    xmlstarlet tr ${XSLT_NORMALIZE} WP4321_98055.roundtrip.gpml > WP4321_98055.roundtrip.norm.gpml
#    diff -dy --suppress-common-lines WP4321_98055.norm.gpml WP4321_98055.roundtrip.norm.gpml
#    rm WP4321_98055.norm.gpml WP4321_98055.roundtrip.norm.gpml

    rm WP4321_98000_98055.patch WP4321_98000.gpml WP4321_98055.gpml

    # TODO convert this old GPML file to use an updated schema:
    #./gpmlconvert ../example-data/Hs_Apoptosis.gpml Hs_Apoptosis-2013a.gpml

    ./gpmlconvert ${WP1243_69897} ./WP1243_69897.owl
    xmlstarlet tr ${XSLT_NORMALIZE} WP1243_69897.owl > WP1243_69897.owl.norm
    mv WP1243_69897.owl.norm WP1243_69897.owl
    cp ${WP1243_69897_BPSS_SHASUM} ./WP1243_69897.bpss.shasum
    cp ${WP1243_69897_OWL_SHASUM} ./WP1243_69897.owl.shasum
    ${coreutils}/bin/sha256sum -c WP1243_69897.bpss.shasum
    # NOTE: if they don't match, try this to see the diff:
    #diff -dy --suppress-common-lines ${WP1243_69897_OWL} WP1243_69897.owl
    ${coreutils}/bin/sha256sum -c WP1243_69897.owl.shasum
    rm WP1243_69897.owl WP1243_69897.owl.shasum WP1243_69897.bpss WP1243_69897.bpss.shasum

    ./gpmlconvert ${WP1243_69897} ./WP1243_69897.png
    cp ${WP1243_69897_PNG_SHASUM} ./WP1243_69897.png.shasum
    # TODO why does the sha256sum differ between Linux and Darwin?
    #${coreutils}/bin/sha256sum -c WP1243_69897.png.shasum
    rm WP1243_69897.png WP1243_69897.png.shasum

    ./gpmlconvert ${WP1243_69897} WP1243_69897.pdf
    # NOTE: PDF conversion produces a different output every time,
    # so we can't use shasum to verify.
    rm WP1243_69897.pdf

    cd ../
  '';

  desktopItem = makeDesktopItem {
    name = name;
    exec = "pathvisio";
    #exec = "pathvisio ~/pathway-\$(${date} -j -f \"%a %b %d %T %Z %Y\" \"\$(${date})\" \"+%s\").gpml";
    #exec = "pathvisio ~/pathway-test.gpml";
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
    echo '  gpmldiff WP1243_69897.gpml test.gpml > test.patch'
    echo '  # Patch'
    echo '  gpmlpatch WP1243_69897.gpml < test.patch'
  '' + (
  if headless then ''
    echo 'Desktop functionality not enabled.'
  '' else ''
    ${installPathVisioGUILauncher}
  '' + (
    if stdenv.system == "x86_64-darwin" then ''
      mkdir -p "$out/Applications"
      unzip -o release/${baseName}.app.zip -d "$out/Applications/"

      # TODO develop a good script for this. I can do one of two options:

#      # 1. use semi-generic JavaApplicationStub
#      substituteInPlace ./JavaApplicationStub \
#            --replace "JAVACMD=\"JAVACMD_REPLACE_ME\"" "JAVACMD=\"${javaPath}\""
#      cp ./JavaApplicationStub $out/Applications/PathVisio.app/Contents/MacOS/JavaApplicationStub

      # 2. use my own pathvisio script
      cp $out/bin/pathvisio $out/Applications/PathVisio.app/Contents/MacOS/pathvisio
      substituteInPlace $out/Applications/PathVisio.app/Contents/Info.plist \
            --replace "JavaApplicationStub" "pathvisio"
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
