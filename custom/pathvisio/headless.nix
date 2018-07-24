{ callPackage,
  organism ? "Homo sapiens", 
  genes ? "webservice",
  interactions ? false,
  metabolites ? "webservice"
}:

with builtins;

callPackage ./default.nix {
  inherit organism genes interactions metabolites;
  headless = true;
}
