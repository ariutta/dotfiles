{ callPackage, organism ? "Homo sapiens", datasources ? {} }:

callPackage ./common.nix {
  inherit datasources organism;
  buildType = "headless";
  desktop = false;
}
