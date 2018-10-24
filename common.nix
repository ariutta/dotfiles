# See README.md for instructions on installing/updating.
with import <nixpkgs> { config.allowUnfree = true; };
let
  custom = import ./nixpkgs-custom/all-custom.nix;
  nixos = import <nixos> { config.allowUnfree = true; };
in [
  # nix-prefetch-scripts is a dependency of composer2nix
  pkgs.nix-prefetch-scripts
  custom.composer2nix

  ####################
  # Deps for powerline
  ####################
  # TODO what is the relationship with Bash-it's powerline theme?
  # https://github.com/Bash-it/bash-it/tree/master/themes/powerline
  # TODO does the powerline package automatically install the powerline fonts?
  pkgs.powerline-fonts

  # NOTE: the PyPi name is powerline-status, but the Nix name is just powerline.
  # NOTE: I added lines to ./.bashrc.public, as instructed here:
  # http://powerline.readthedocs.io/en/master/usage/shell-prompts.html#bash-prompt
  pkgs.python36Packages.powerline

  pkgs.coreutils
  pkgs.jq
  pkgs.gettext
  pkgs.ripgrep
  pkgs.pypi2nix
  pkgs.nix-repl
  pkgs.nox
  nixos.gawkInteractive
  nixos.nodePackages.node2nix
  custom.bash-it
  custom.tosheets
  custom.vim
  pkgs.wget
] ++ (if stdenv.isDarwin then [] else [])
