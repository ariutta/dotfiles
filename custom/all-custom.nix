{ callPackage }:

{

  black = callPackage ./black/default.nix {}; 
  composer2nix = callPackage ./composer2nix/default.nix {}; 
  mediawiki-codesniffer = callPackage ./mediawiki-codesniffer/default.nix {};
  perlPackages = callPackage ./perl-packages.nix {}; 
  pgsanity = callPackage ./pgsanity/default.nix {};
  privoxy = callPackage ./privoxy/darwin-service.nix {}; 
  sqlint = callPackage ./sqlint/default.nix {};
  tosheets = callPackage ./tosheets/default.nix {};
  vim = callPackage ./vim/default.nix {};

}
