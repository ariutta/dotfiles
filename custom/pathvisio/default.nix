{ callPackage, datasources ? [], desktop ? true }:

callPackage ./common.nix {
  inherit datasources desktop;
  buildType = null;
}
