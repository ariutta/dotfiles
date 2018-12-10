# See README.md for instructions on installing/updating.
with import <nixpkgs> { config.allowUnfree = true; };
let
  custom = import ./nixpkgs-custom/all-custom.nix;
in [
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

  # To setup keys for GitHub:
  # https://github.com/settings/keys

  # openssh includes ssh-copy-id
  pkgs.openssh

  pkgs.gnupg
  # TODO: do we need gpgme?
  #pkgs.gpgme

  # Suggested for use by GitHub, but does it work with Docker?
  #pkgs.xclip

  pkgs.coreutils
  pkgs.less
  pkgs.rsync
  pkgs.jq
  pkgs.gettext
  pkgs.ripgrep
  pkgs.nox
  pkgs.gawkInteractive
  custom.bash-it
  custom.vim
  pkgs.wget
] ++ (if stdenv.isDarwin then [] else [])
