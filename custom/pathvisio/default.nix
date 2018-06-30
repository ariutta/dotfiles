{ callPackage,
organism ? "Homo sapiens",
desktop ? true,
genes ? "webservice",
interactions ? false,
metabolites ? "webservice"
}:

with builtins;

getAttr organism (callPackage ./all.nix {
  inherit desktop genes interactions metabolites;
})
