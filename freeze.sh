#!/bin/bash
set -e
########################################
time nix-shell --show-trace --run 'cabal new-freeze' 
mkdir -p release/
mv cabal.project.freeze release/
cat release/cabal.project.freeze
########################################
