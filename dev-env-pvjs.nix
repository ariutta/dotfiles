with import <nixpkgs> { config.allowUnfree = true; };
let
  dev-env-js = import ./dev-env-js.nix;
  custom = import ./nixpkgs-custom/all-custom.nix;
in dev-env-js ++ [
  pkgs.libxml2 # for xmllint

  # node-gyp dependencies
  # see https://github.com/nodejs/node-gyp#on-unix
  # (Required for building node-expat)
  pkgs.python2

] ++ (if stdenv.isDarwin then [
  # more node-gyp dependencies
  # XCode Command Line Tools
  # TODO: do we need cctools?
  #pkgs.darwin.cctools
] else [

  # more node-gyp dependencies

  pkgs.gnumake

  # gcc and binutils disagree on the version of a
  # dependency, so we need to binutils-unwrapped.
  pkgs.gcc # also provides cc
  pkgs.binutils-unwrapped # provides ar

])
