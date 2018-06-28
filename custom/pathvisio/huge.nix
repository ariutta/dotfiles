{ callPackage, fetchzip, desktop ? true, organism ? "Homo sapiens" }:

with builtins;

let
  datasources = callPackage ./datasources.nix {};
in
callPackage ./common.nix {
  inherit desktop;
  buildType = "huge";
  datasources = {
    gene = getAttr organism datasources;
    interaction = datasources.interaction;
    metabolite = datasources.metabolite;
  };
}
