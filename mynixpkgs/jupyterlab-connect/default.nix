{
fetchFromGitHub,
installShellFiles,
argbash,
help2man,
gnused,
stdenv }:

with builtins;

let
  baseName = "jupyterlab-connect";
  version = "94da167c86d4aa573becb6faaa43175cdfd58e57";
in
stdenv.mkDerivation rec {
  name = (concatStringsSep "-" [baseName version]);

  nativeBuildInputs = [ argbash help2man installShellFiles ];

  # buildInputs may be used at run-time but are only on the PATH at build-time.
  #   From the manual:
  #   "These often are programs/libraries used by the new derivation at
  #    run-time, but that isn't always the case."
  buildInputs = [ gnused ];

  # for dev:
  #src = /home/ariutta/Documents/jupyterlab-connect;
  # for prod:
  src = fetchFromGitHub {
    owner = "ariutta";
    repo = "jupyterlab-connect";
    rev = version;
    sha256 = "0mzfx3aafwzzmm5hfx77ysgczj7ggmh9q9ba4k8zrkb8g509lwqi";
  };

  preBuild = ''
    patchShebangs ./bin/jupyterlab-connect
    patchShebangs ./bin/*.sh
    patchShebangs ./lib/*.sh
  '';

  doCheck = true;

  checkPhase = ''
    if [ ! -e "./lib/jupyterlab-connect" ]; then
      echo "test failed: ./lib/jupyterlab-connect does not exist"
      exit 1;
    fi

    if ! ./bin/jupyterlab-connect --help >/dev/null; then
      echo "test failed: cannot run ./bin/jupyterlab-connect --help"
      exit 1;
    fi
  '';

  installPhase = ''
    mkdir -p "$out"

    binDir="$out/bin"
    mkdir -p "$binDir"

    libDir="$out/lib"
    mkdir -p "$libDir"

    shareDir="$out/share"
    mkdir -p "$shareDir"

    completionsDir="$shareDir/completions"
    mkdir -p "$completionsDir"

    manDir="$shareDir/man"
    mkdir -p "$manDir"

    #infoDir="$shareDir/info"
    #mkdir -p "$infoDir"

    cp ./bin/jupyterlab-connect "$binDir"
    #cp ./bin/*.sh "$binDir"
    cp ./lib/jupyterlab-connect "$libDir"
    cp ./lib/*.sh "$libDir"

    cp -r ./share/* "$shareDir/"
    installManPage "$manDir/jupyterlab-connect.1"

    # explicit behavior
    installShellCompletion --bash --name jupyterlab-connect.bash share/completions/jupyterlab-connect
    #installShellCompletion --fish --name foobar.fish share/completions/completions.fish
    #installShellCompletion --zsh --name _foobar share/completions/completions.zsh
    # implicit behavior
    #installShellCompletion share/completions/completions.{bash,fish,zsh}
  '';

  meta = with stdenv.lib;
    { description = "Connect to your jupyterlab server";
      homepage = https://github.com/ariutta/jupyterlab-connect;
      license = licenses.mit;
      maintainers = with maintainers; [ ariutta ];
      platforms = platforms.all;
    };
}
