#!/bin/bash
set -e
########################################
time nix-shell --show-trace --run 'cabal new-build' 
########################################
