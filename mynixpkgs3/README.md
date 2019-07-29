# Cheatsheet for creating custom packages

## Test a package expression

```sh
nix-build -E 'with import <nixpkgs> { }; callPackage ./default.nix {}'
./result/bin/abc --help
```

## Python

Generate Nix expressions for python packages by using pypi2nix.

### Applications

For python packages used as stand-alone applications (even if also used as dependencies):

```sh
mkdir -p tosheets
cd tosheets
pypi2nix -V 3 -e tosheets==0.3.0
```

### Dependency-Only

For packages used only as dependencies (never as stand-alone applications):

```sh
mkdir -p python-packages
cd python-packages
pypi2nix -V 3 -e homoglyphs==1.2.5 -e confusable_homoglyphs==3.1.1
```

Then convert the resulting output into a single expression that can be added to [python-packages.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/python-packages.nix).

## [Ruby](https://nixos.org/nixpkgs/manual/#sec-language-ruby)

Get or create a Gemfile for the package. Then follow the manual's instructions to run bundix and create a default.nix file. Put the following files under version control:

* default.nix
* Gemfile
* Gemfile.lock
* gemset.nix
