with import <nixpkgs> { config.allowUnfree = true; };
let
  black = callPackage ../black/default.nix {}; 
  perlPackagesCustom = callPackage ../perl-packages.nix {}; 
in [
  # Custom Dependencies

  # Deps for Syntastic (Syntax Checker)
  # * sqlint (TODO: install)
  #     https://github.com/purcell/sqlint
  #     Another option: pgsanity (although it's not currently one of the Syntastic-supported options)
  #       https://github.com/markdrago/pgsanity
  pkgs.shellcheck

  # Deps for Neoformat
  pkgs.python36Packages.jsbeautifier
  pkgs.shfmt
  # TODO see comment above about this dep.
  black
  pkgs.python36Packages.sqlparse
  perlPackagesCustom.pgFormatter
  # TODO Create Nix pkg for prettier and install
  # prettier
]
