#!/bin/bash
set -e
########################################
time nix-shell --run 'cabal new-test doctest' 
########################################
