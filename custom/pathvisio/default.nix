{ callPackage, datasources ? {}, desktop ? true, organism ? "Homo sapiens" }:

callPackage ./common.nix {
  inherit datasources desktop organism;
  buildType = null;
}
