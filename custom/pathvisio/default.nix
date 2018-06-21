# some docs
# https://developer.apple.com/library/archive/documentation/Java/Conceptual/Java14Development/03-JavaDeployment/JavaDeployment.html

# some of the CLI args allowed
# https://github.com/PathVisio/pathvisio/blob/master/modules/org.pathvisio.launcher/src/org/pathvisio/launcher/PathVisioMain.java
{ stdenv, fetchurl, fetchFromGitHub, makeDesktopItem, unzip, ant, jdk }:

let
  baseName = "PathVisio";
  version = "3.3.0";
in
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  # should this be nativeBuildInputs or just buildInputs?
  nativeBuildInputs = [ unzip ant jdk ];

  javaPath = "${jdk.jre}/bin/java";

#  src = fetchurl {
#    url = "https://www.pathvisio.org/data/releases/current/pathvisio_bin-${version}.zip";
#    sha256 = "0wpnxkc9fs9h3n0p5y7j8b28gpvyhac4kw0vbqi9j5q6hphi0fs0";
#  };

  # TODO build from source instead of downloading binary
  src = fetchFromGitHub {
    owner = "pathvisio";
    repo = "PathVisio";
    rev = "61f15de96b676ee581858f0485f9c6d8f61a3476";
    sha256 = "1n2897290g6kph1l04d2lj6n7137w0gnavzp9rjz43hi1ggyw6f9";
  };

  srcPngIcon = fetchurl {
    url = "https://www.pathvisio.org/wcms/wp-content/uploads/2013/03/pathvisio-eye-switch-e1363105300175.png";
    sha256 = "1ywi2d4iyg1ppgmmclzamanqlhihk8dad54qfx7cl3405y80bqir";
  };

  srcBiopax3GPML = fetchurl {
    url = "https://cdn.rawgit.com/wikipathways/wikipathways.org/e8fae01e/wpi/bin/Biopax3GPML.jar";
    sha256 = "1jm5khh6n78fghd7wp0m5dcb6s2zp23pgsbw56rpajfxgx1sz7lg";
  };

#  # TODO use this https://github.com/PathVisio/pathvisio/blob/master/Info.plist
#  plistSrc = ./Info.plist;
#
#  iconSrc = fetchurl {
#    url = "https://cdn.rawgit.com/PathVisio/pathvisio/61f15de9/lib-build/bigcateye.icns";
#    sha256 = "1ygjcjbnabilfxvzbaamzr739f2b8l1gy56jnq2lxk9i2nxkqgxq";
#  };
#
#  bridgerestSrc = fetchurl {
#    url = "https://cdn.rawgit.com/PathVisio/pathvisio/61f15de9/lib/org.bridgedb.webservice.bridgerest.jar";
#    sha256 = "1s3xmvqpm6m6x70hn4mlfvspkrsmlj2ixba9hfgpsr9q5v144d8z";
#  };

  # sh ./result/bin/pathvisio -p ./org.bridgedb.webservice.bridgerest.jar

#  # WARNING: this is very large
#  metaboliteSrc = fetchurl {
#    url = "http://bridgedb.org/data/gene_database/metabolites_20180508.bridge.zip";
#    sha256 = "13l3p755k3k4vp2zg24fbsmprbgml75cg105qmzs85xipz92cqv4";
#  };

  postPatch = ''
    substituteInPlace ./pathvisio.sh \
          --replace "java" "${javaPath}" \
          --replace "cd" "#cd" \
          --replace "pathvisio.jar" "$out/lib/pathvisio/pathvisio.jar"
  '';

  buildPhase = "ant";
  #buildPhase = "ant zip";
  #buildPhase = "ant core.jar";
  #buildPhase = "ant launcher.jar";

#  postBuild = ''
#    echo "****************** postBuild "******************"
#    echo "ls -la ./"
#    ls -la ./
#  '';

  # TODO is this just for Linux?
  desktopItem = makeDesktopItem {
    name = name;
    exec = ''
      ${javaPath} -jar -Dfile.encoding=UTF-8 $out/lib/pathvisio/pathvisio.jar "\$@"
    '';
    icon = "${srcPngIcon}";
    desktopName = baseName;
    # TODO what is genericName?
    genericName = "IDE";
    comment = meta.description;
    # TODO what is categories?
    categories = "Development;";
    mimeType = "application/gpml+xml";
  };

  installPhase = ''
    echo '****************** installPhase "******************'
    pwd
    echo 'ls -la ./'
    ls -la ./
    mkdir -p $out/lib/pathvisio $out/bin
    cp -r ./ $out/

    cat > $out/bin/gpmlconverter <<EOF
    #! $shell
    CLASSPATH=$out/modules/org.pathvisio.core.jar:$out/lib/*:${srcBiopax3GPML}
    exec ${jdk.jre}/bin/java -ea -classpath \$CLASSPATH org.pathvisio.core.util.Converter "\$@"
    EOF

    chmod a+x $out/bin/gpmlconverter

    echo 'try'
    echo './result/bin/gpmlconverter WP1229_71445.gpml png.png'
  '' + (
  if stdenv.system == "x86_64-darwin" then ''
    #mkdir -p "$out/Applications/${baseName}.app/Contents/MacOS" "$out/Applications/${baseName}.app/Contents/Resources"

    echo '****************** </installPhase> "******************'
    pwd

    echo 'ls -la ./'
    ls -la ./

    echo 'ls -la $out'
    ls -la $out

    echo 'ls -la ./release'
    ls -la ./release
  '' else ''
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '');

#  installPhase = ''
#    mkdir -p $out/lib/pathvisio $out/bin
#    cp -r ./pathvisio-${version}/* $out/lib/pathvisio
#    ln -s $out/lib/pathvisio/pathvisio.sh $out/bin/pathvisio
#    chmod a+x "$out/bin/pathvisio"
#  '' + (
#  if stdenv.system == "x86_64-darwin" then ''
#    mkdir -p "$out/Applications/${baseName}.app/Contents/MacOS" "$out/Applications/${baseName}.app/Contents/Resources"
#    cp $out/lib/pathvisio/pathvisio.sh "$out/Applications/${baseName}.app/Contents/MacOS/${baseName}"
#    cp ${iconSrc} "$out/Applications/${baseName}.app/Contents/Resources/${baseName}.icns"
#    cp ${plistSrc} "$out/Applications/${baseName}.app/Contents/Info.plist"
#    chmod a+x "$out/Applications/${baseName}.app/Contents/MacOS/${baseName}"
#  '' else ''
#    ln -s ${desktopItem}/share/applications/* $out/share/applications/
#  '');

  meta = with stdenv.lib;
    { description = "A tool to edit and analyze biological pathways";
      homepage = https://www.pathvisio.org/;
      license = licenses.asl20;
      maintainers = with maintainers; [ ];
      #platforms = with platforms; [ linux darwin ];
      platforms = platforms.all;
    };
}
