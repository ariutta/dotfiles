# See README.md for instructions on installing/updating.

with import <nixpkgs> { config.allowUnfree = true; };
let
  nixos = import <nixos> { config.allowUnfree = true; };
  common = import ./common.nix;
  custom = callPackage ./custom/all-custom.nix {};
in common ++ [

  # Anki installation not currently working on macOS.
  # See https://github.com/NixOS/nixpkgs/issues/40956
  #pkgs.anki
  # Until it's fixed, just manually install from https://apps.ankiweb.net/

  custom.composer2nix
  nixos.irssi
  nixos.lynx
  pkgs.keepassxc
  pkgs.nix-prefetch-scripts
  pkgs.nodejs-8_x

  # openssh includes ssh-copy-id
  nixos.openssh

  # To use pgmanage, first ensure the target DB is available.
  # Is the DB is remote, create a tunnel like this (tunneling local port 3333 to remote port 5432):
  #   ssh -L 3333:wikipathways-workspace.gladstone.internal:5432 ariutta@wikipathways-workspace.gladstone.internal
  # Then you can run "pgmanage" from the command line and open a browser windowa to the URL that is spit out.
  nixos.pgmanage

  #nixos.rstudio
  # The rstudio Nix expression doesn't work on darwin.
  # It currently only supports linux.
  # Earlier, these the steps may have worked on darwin (but they stopped?):
  # 1. Install R with Nix:
  #nixos.R
  # 2. Follow steps in .profile.public regarding R path
  # 3. Install RStudio manually from here:
  #    https://www.rstudio.com/products/rstudio/download/#download

  # I had previously installed java via brew cask.
  # When I stopped using brew, I added the pkg below but haven't confirmed it works.
  # This one is openjdk, but the version from brew cask was probably Oracle's.
  #pkgs.jdk9
] ++ (if stdenv.isDarwin then [] else [])
