{ callPackage }:

{

  black = callPackage ./black/default.nix {}; 
  privoxy = callPackage ./privoxy/darwin-service.nix {}; 
  vim = callPackage ./vim/default.nix {};
  tosheets = callPackage ./tosheets/default.nix {};

  # Generate Nix expressions for python packages using pypi2nix:
  #   For python packages used as applications:
  #     cd custom/tosheets
  #     pypi2nix -V 3 -e tosheets==0.3.0
  #
  #   For packages not used as applications:
  #     cd custom/python-packages
  #     pypi2nix -V 3 -e homoglyphs==1.2.5 -e confusable_homoglyphs==3.1.1

}
