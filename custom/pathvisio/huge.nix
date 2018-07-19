{ callPackage,
  organism ? "Homo sapiens",
  desktop ? true
}:

with builtins;

callPackage ./default.nix {
  inherit organism desktop;
  genes = "local";
  interactions = "local";
  metabolites = "local";
}
