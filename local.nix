# Declarative Package Management for macOS and Linux
# https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
# https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

# Possibly related:
# https://rycee.net/posts/2017-07-02-manage-your-home-with-nix.html
# https://unix.stackexchange.com/questions/369234/how-to-configure-a-nix-environment-outside-of-nixos
# https://github.com/ashgillman/dotfiles2/blob/master/install-ubuntu.sh

# See README.md for instructions on installing/updating.

with import <nixpkgs> { config.allowUnfree = true; };
let
  nixos = import <nixos> { config.allowUnfree = true; };
  common = import ./common.nix;
  custom = callPackage ./custom/all-custom.nix {};
in common ++ [
  custom.composer2nix
  nixos.irssi
  nixos.lynx
  pkgs.nix-prefetch-scripts

  # To use pgmanage, first ensure the target DB is available.
  # Is the DB is remote, create a tunnel like this (tunneling local port 3333 to remote port 5432):
  #   ssh -L 3333:wikipathways-workspace.gladstone.internal:5432 ariutta@wikipathways-workspace.gladstone.internal
  # Then you can run "pgmanage" from the command line and open a browser windowa to the URL that is spit out.
  nixos.pgmanage

  # openssh includes ssh-copy-id
  nixos.openssh

  pkgs.keepassxc
  pkgs.nodejs-8_x

  # Not working on macOS at present.
  # See https://github.com/NixOS/nixpkgs/issues/40956
  # Manually install from https://apps.ankiweb.net/
  #pkgs.anki

  # brew cask used to list java, virtualbox and rstudio.
  # These are semi-moved over here now.

  # TODO Do I still want to use this?
  #pkgs.virtualbox

  #nixos.rstudio
  # The rstudio Nix expression doesn't work on darwin.
  # It currently only supports linux.
  # Earlier, these are the steps worked on darwin (but they stopped?):
  # 1. Install R with Nix:
  #nixos.R
  # 2. Follow steps in .profile.public regarding R path
  # 3. Install RStudio manually from here:
  #    https://www.rstudio.com/products/rstudio/download/#download

  #pkgs.jdk9 # this one is openjdk, but brew cask is probably Oracle's.
] ++ (if stdenv.isDarwin then [] else [])
