#!/bin/bash
set -e
########################################
nix-shell -p zlib -p haskellPackages.alex -p haskellPackages.happy --command 'cabal --enable-nix new-build all'
########################################
