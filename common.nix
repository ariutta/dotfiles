# See README.md for instructions on installing/updating.
with import <nixpkgs> { config.allowUnfree = true; };
let
  custom = callPackage ./custom/all-custom.nix {};
  nixos = import <nixos> { config.allowUnfree = true; };
in [
  ####################
  # Deps for powerline
  ####################
  # TODO what is the relationship with Bash-it's powerline theme?
  # https://github.com/Bash-it/bash-it/tree/master/themes/powerline
  # TODO does the powerline package automatically install the powerline fonts?
  #pkgs.powerline-fonts
  # NOTE: the PyPi name is powerline-status, but the Nix name is just powerline.
  pkgs.python36Packages.powerline
  # NOTE: I added lines to ./.bashrc.public, as instructed here:
  # http://powerline.readthedocs.io/en/master/usage/shell-prompts.html#bash-prompt

  custom.tosheets
  custom.vim

  nixos.jq
  nixos.gettext
  nixos.ripgrep

  # NOTE: pkgs means nixpkgs.pkgs
  pkgs.pypi2nix
  pkgs.nix-repl
  pkgs.nox
  pkgs.nodePackages.node2nix
  pkgs.wget
] ++ (if stdenv.isDarwin then [] else [])
