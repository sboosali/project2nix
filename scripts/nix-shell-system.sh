#!/bin/bash
set -e
########################################
nix-shell -p zlib -p haskellPackages.alex haskellPackages.happy --command 'cabal new-build all; return'
########################################
