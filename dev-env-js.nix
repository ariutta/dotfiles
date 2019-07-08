# See README.md for instructions on installing/updating.

with import <nixpkgs> { config.allowUnfree = true; };
let
  common = import ./common.nix;
in common ++ [

  pkgs.nsjail

  pkgs.nodejs-8_x
  pkgs.nodePackages.node2nix

  # Yarn ecosystem?
  #pkgs.nodePackages.lerna
  #pkgs.yarn
  # what about yarn2nix?
  #pkgs.yarn2nix

] ++ (if stdenv.isDarwin then [] else [])
