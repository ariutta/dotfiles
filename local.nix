# Declarative Package Management for macOS and Linux
# https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
# https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

# Possibly related:
# https://rycee.net/posts/2017-07-02-manage-your-home-with-nix.html
# https://unix.stackexchange.com/questions/369234/how-to-configure-a-nix-environment-outside-of-nixos
# https://github.com/ashgillman/dotfiles2/blob/master/install-ubuntu.sh

# See README.md for instructions on installing/updating.

with import <nixpkgs> {config.vim.ftNix = false;};
let
  nixos = import <nixos> {};
  privoxyCustom = callPackage ./custom/privoxy/privoxy-darwin.nix {}; 
in [
  nixos.irssi
  nixos.lynx
  nixos.toot
  nixos.pgmanage

  # openssh includes ssh-copy-id
  nixos.openssh

  pkgs.keepassxc
  pkgs.nodejs-8_x

  # Not working on macOS at present.
  # See https://github.com/NixOS/nixpkgs/issues/40956
  # Manually install from https://apps.ankiweb.net/
  #pkgs.anki

  # the following used to be installed via brew cask:
  #pkgs.virtualbox
  #nixos.rstudio # "nix-env -iA nixos.rstudio" doesn't work on darwin (linux only)
  #pkgs.jdk9 # this one is openjdk, but brew cask is probably Oracle's.


  # TODO Make pull request to nixpkgs repo with an update
  #      to privoxy Nix expression so that it works on
  #      both linux and darwin.
  # NOTE See ./custom/privoxy/privoxy-darwin.nix for a note
  #      on how to start privoxy as a service.
  privoxyCustom
] ++ (if stdenv.isDarwin then [] else [])
