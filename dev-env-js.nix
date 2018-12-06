# See README.md for instructions on installing/updating.

with import <nixpkgs> { config.allowUnfree = true; };
let
  common = import ./common.nix;
  custom = import ./nixpkgs-custom/all-custom.nix;
  nixos = import <nixos> { config.allowUnfree = true; };
in common ++ [

  pkgs.nodejs-8_x
  pkgs.nodePackages.node2nix
  pkgs.nodePackages.lerna

  # openssh includes ssh-copy-id
  pkgs.openssh

] ++ (if stdenv.isDarwin then [] else [])
