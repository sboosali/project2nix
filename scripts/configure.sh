#!/bin/bash
set -e
########################################
#./nix-shell.sh --run "cabal new-configure $*" 
cabal new-configure "$*" 
########################################
