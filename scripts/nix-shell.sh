#!/bin/bash
set -e
########################################

echo
echo '[ARGUMENTS (one per line)]'
echo
printf '%s\n\n' "$@" 
echo

echo '[nix-shell ...]'
echo

time nix-shell --show-trace "$@"

########################################
