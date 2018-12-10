# See README.md for instructions on installing/updating.

with import <nixpkgs> { config.allowUnfree = true; };
let
  common = import ./common.nix;
  custom = import ./nixpkgs-custom/all-custom.nix;
  nixos = import <nixos> { config.allowUnfree = true; };
in common ++ [

  pkgs.python2
  pkgs.nodejs-8_x
  pkgs.nodePackages.lerna
  pkgs.yarn
  pkgs.nodePackages.node2nix
  # what about yarn2nix?
  #pkgs.yarn2nix
  pkgs.libxml2 # for xmllint

] ++ (if stdenv.isDarwin then [] else [])
