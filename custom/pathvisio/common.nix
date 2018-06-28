{ stdenv, fetchurl, fetchFromGitHub, makeDesktopItem, unzip, ant, jdk, buildType, desktop ? true, organism ? "Homo sapiens", datasources ? {} }:

with builtins;

let
  baseName = "PathVisio";
  version = "3.3.0";
in
stdenv.mkDerivation rec {
  name = concatStringsSep "-" (filter (x: isString x) [baseName version buildType]);

  # should this be nativeBuildInputs or just buildInputs?
  nativeBuildInputs = [ unzip ant jdk ];
  #buildInputs = [datasources.gene datasources.interaction datasources.metabolite];
  buildInputs = (attrValues datasources);

  #pathvisioPlugins = readFile ./pathvisio.xml;
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

  # TODO look into giving the option to use a local download of the datasources
  #datasourcesFlags = builtins.reduce datasources
  # once the above is figured out, it might be possible to append
  # datasourcesFlags to pathvisioJarCpCmd
  #datasourcesFlags = builtins.concatStringsSep " " (builtins.map (d: "-p " + d) datasources);
  #datasourcesFlags = concatStringsSep " " (map (d: "-d ${d.outPath}/${d.name}.bridge") datasources);
  #datasourcesFlags = concatStringsSep " " (map (d: "-d ${d.outPath}/datasource.bridge") datasources);
  #${javaPath} -jar -Dfile.encoding=UTF-8 ${sharePath1}/pathvisio.jar ${datasourcesFlags} "\$@"

  pathvisioJarCpCmd = ''
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
      #cd "\$HOME/.PathVisio/.bundles" || exit
      #ln -s "${bridgedbSettings}" "./pvplugins-bridgedbSettings-1.0.0.jar"

      #cp "${bridgedbSettings}" "\$HOME/.PathVisio/.bundles/pvplugins-bridgedbSettings-1.0.0.jar"
      #chmod u+rx "\$HOME/.PathVisio/.bundles/pvplugins-bridgedbSettings-1.0.0.jar"

      ln -s "${bridgedbSettings}" "\$HOME/.PathVisio/.bundles/pvplugins-bridgedbSettings-1.0.0.jar"
      cat ${pathvisioPlugins} > "\$HOME/.PathVisio/.bundles/pathvisio.xml"
      sed -i.bak "s#HOME_REPLACE_ME#\$HOME#g" "\$HOME/.PathVisio/.bundles/pathvisio.xml"
    fi

    # TODO when, if ever, do we want to use the "-x" flag?
    if grep -Fq "BRIDGEDB_CONNECTION" "\$PREFS_FILE"
    then
      # code if found
      echo 'Connected to BridgeDb webservice.'
    else
      # code if not found
      echo 'BRIDGEDB_CONNECTION_1=idmapper-bridgerest\\:http\\://webservice.bridgedb.org\\:80/${organism}' >> "\$PREFS_FILE"
    fi
  '' + (if hasAttr "gene" datasources then ''
    if grep -Fq "DB_CONNECTSTRING_GDB" "\$PREFS_FILE"
    then
      # code if found
      sed -i.bak 's#DB_CONNECTSTRING_GDB=idmapper-pgdb\\\\:.*\$#DB_CONNECTSTRING_GDB=idmapper-pgdb\\\\:${datasources.gene.outPath}/${datasources.gene.name}.bridge#' "\$PREFS_FILE"
    else
      # code if not found
      echo 'DB_CONNECTSTRING_GDB=idmapper-pgdb\\:${datasources.gene.outPath}/${datasources.gene.name}.bridge' >> "\$PREFS_FILE"
    fi
  '' else ''
      # do nothing
    ''
  ) + (if hasAttr "interaction" datasources then ''
    if grep -Fq "DB_CONNECTSTRING_IDB" "\$PREFS_FILE"
    then
      # code if found
      sed -i.bak 's#DB_CONNECTSTRING_IDB=idmapper-pgdb\\\\:.*\$#DB_CONNECTSTRING_IDB=idmapper-pgdb\\\\:${datasources.interaction.outPath}/${datasources.interaction.name}.bridge#' "\$PREFS_FILE"
    else
      # code if not found
      echo 'DB_CONNECTSTRING_IDB=idmapper-pgdb\\:${datasources.interaction.outPath}/${datasources.interaction.name}.bridge' >> "\$PREFS_FILE"
    fi
  '' else ''
      # do nothing
    ''
  ) + (if hasAttr "metabolite" datasources then ''
    if grep -Fq "DB_CONNECTSTRING_METADB" "\$PREFS_FILE"
    then
      # code if found
      sed -i.bak 's#DB_CONNECTSTRING_METADB=idmapper-pgdb\\\\:.*\$#DB_CONNECTSTRING_METADB=idmapper-pgdb\\\\:${datasources.metabolite.outPath}/${datasources.metabolite.name}.bridge#' "\$PREFS_FILE"
    else
      # code if not found
      echo 'DB_CONNECTSTRING_METADB=idmapper-pgdb\\:${datasources.metabolite.outPath}/${datasources.metabolite.name}.bridge' >> "\$PREFS_FILE"
    fi
  '' else ''
      # do nothing
    ''
  ) + ''
    cd \$(dirname \$0) || exit
    ${javaPath} -jar -Dfile.encoding=UTF-8 ${sharePath1}/pathvisio.jar "\$@"
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
    #name = replaceStrings [" "] ["_"] "${name}-${organism}";
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
    ${pathvisioJarCpCmd}
  '' + (
    if stdenv.system == "x86_64-darwin" then ''
      mkdir -p "$out/Applications"
      unzip -o release/${baseName}.app.zip -d "$out/Applications/"
    '' else ''
      mkdir -p "$out/share/applications"
      ln -s ${desktopItem}/share/applications/* "$out/share/applications/"
    ''
  ));

  meta = with stdenv.lib;
    { description = "A tool to edit and analyze biological pathways";
      homepage = https://www.pathvisio.org/;
      license = licenses.asl20;
      maintainers = with maintainers; [ ariutta ];
      platforms = platforms.all;
    };
}
