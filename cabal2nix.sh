#!/bin/bash
set -e
########################################
cabal2nix .         $@ > ./project2nix.nix
########################################
cabal2nix . --shell $@ > ./shell.project2nix.nix
########################################
echo
echo '[default.nix]'
echo
cat ./default.nix

echo
echo '[shell.nix]'
echo
cat ./shell.nix

echo
echo '[project2nix.nix]'
echo
cat ./project2nix.nix

echo
echo '[shell.project2nix.nix]'
echo
cat ./shell.project2nix.nix
########################################
./nix-shell.sh --run 'ghc-pkg list'
########################################
