{ stdenv, fetchurl, fetchFromGitHub, makeDesktopItem, unzip, ant, jdk }:

let
  appName = "PathVisio";
  version = "3.3.0";
in
stdenv.mkDerivation rec {
  name = "${appName}-${version}";

  nativeBuildInputs = [ unzip ant jdk ];

  #buildInputs = [ boost zlib openssl R qtbase qtwebkit qtwebchannel libuuid ];

  javaPath = "${jdk.jre}/bin/java";

  src = fetchurl {
    url = "https://www.pathvisio.org/data/releases/current/pathvisio_bin-${version}.zip";
    sha256 = "0wpnxkc9fs9h3n0p5y7j8b28gpvyhac4kw0vbqi9j5q6hphi0fs0";
  };

  # TODO build from source instead of downloading binary
#  src = fetchFromGitHub {
#    owner = "pathvisio";
#    repo = "PathVisio";
#    rev = "61f15de96b676ee581858f0485f9c6d8f61a3476";
#    sha256 = "1kqgik75jx681s1kjx1s7dryigr3m940c3zb9vy0r3psxrw6sf21";
#  };

  iconSrcPng = fetchurl {
    url = "https://www.pathvisio.org/wcms/wp-content/uploads/2013/03/pathvisio-eye-switch-e1363105300175.png";
    sha256 = "1ywi2d4iyg1ppgmmclzamanqlhihk8dad54qfx7cl3405y80bqir";
  };

  plistSrc = ./Info.plist;

  iconSrc = fetchurl {
    url = "https://cdn.rawgit.com/PathVisio/pathvisio/61f15de9/lib-build/bigcateye.icns";
    sha256 = "1ygjcjbnabilfxvzbaamzr739f2b8l1gy56jnq2lxk9i2nxkqgxq";
  };

  unpackPhase = ''
    echo "unpackPhase"
    unzip ${src} -d ./
  '';

  postPatch = ''
    substituteInPlace ./pathvisio-${version}/pathvisio.sh \
          --replace "java" "${javaPath}" \
          --replace "cd" "#cd" \
          --replace "pathvisio.jar" "$out/lib/pathvisio/pathvisio.jar"
  '';

  dontBuild = true;
  #builder = "./pathvisio.sh";
#  buildCommand = ''
#    echo "buildCommand"
#    ls -la ./
#    ls -la $out/
#    $out/pathvisio.sh
#  '';

  desktopItem = makeDesktopItem {
    name = name;
    exec = ''
      ${javaPath} -jar -Dfile.encoding=UTF-8 $out/lib/pathvisio/pathvisio.jar "\$@"
    '';
    icon = "${iconSrcPng}";
    desktopName = appName;
    genericName = "IDE";
    comment = meta.description;
    categories = "Development;";
    mimeType = "application/gpml+xml";
  };

  installPhase = ''
    echo "installPhase"

    mkdir -p $out/lib/pathvisio $out/bin
    cp -r ./pathvisio-${version}/* $out/lib/pathvisio

    ln -s $out/lib/pathvisio/pathvisio.sh $out/bin/pathvisio

    #exec ${jdk.jre}/bin/java -jar -Dfile.encoding=UTF-8 $out/share/pathvisio/pathvisio.jar "\$@"
    #sh /nix/store/k1sjc92xcbmfdd90w26xp3y2jylf9h7x-PathVisio-3.3.0/share/pathvisio/pathvisio.sh
    #/nix/store/fgx4nvl9v1b7mvhvyszvjh1mhw94hj9r-zulu1.8.0_121-8.20.0.5/bin/java -jar /nix/store/vwjhk7ivi7qydzi6n13yi1kqj72avn7p-PathVisio-3.3.0/share/pathvisio/pathvisio.jar "$@"
    #${javaPath} -jar -Dfile.encoding=UTF-8 $out/share/pathvisio/pathvisio.jar "\$@"

    #ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '' + (
  if stdenv.system == "x86_64-darwin" then ''
    mkdir -p "$out/Applications/${appName}.app/Contents/MacOS" "$out/Applications/${appName}.app/Contents/Resources"
    cp $out/lib/pathvisio/pathvisio.sh "$out/Applications/${appName}.app/Contents/MacOS/${appName}"
    cp ${iconSrc} "$out/Applications/${appName}.app/Contents/Resources/${appName}.icns"

    cp ${plistSrc} "$out/Applications/${appName}.app/Contents/Info.plist"

    chmod a+x "$out/Applications/${appName}.app/Contents/MacOS/${appName}"
  '' else ''
    #ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '');

  #enableParallelBuilding = true;

  #cmakeFlags = [ "-DRSTUDIO_TARGET=Desktop" "-DQT_QMAKE_EXECUTABLE=$NIX_QT5_TMP/bin/qmake" ];

#  postInstall = ''
#    echo "postInstall"
#    echo "ls -la ${desktopItem}"
#    ls -la ${desktopItem}
#
#    echo "ls -la ${desktopItem}/share/applications"
#    ls -la ${desktopItem}/share/applications
#
#    cp -r ${desktopItem}/share/applications $out/share
#    mkdir $out/share/icons
#    ln ${iconSrc} $out/share/icons
#  '';

  meta = with stdenv.lib;
    { description = "A tool to edit and analyze biological pathways";
      homepage = https://www.pathvisio.org/;
      license = licenses.asl20;
      maintainers = with maintainers; [ ];
      #platforms = with platforms; [ linux darwin ];
      platforms = platforms.all;
    };
}
