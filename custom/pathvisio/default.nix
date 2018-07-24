{ callPackage,
organism ? "Homo sapiens",
headless ? false,
genes ? "webservice",
interactions ? false,
metabolites ? "webservice"
}:

with builtins;

getAttr organism (callPackage ./all.nix {
  inherit headless genes interactions metabolites;
})
