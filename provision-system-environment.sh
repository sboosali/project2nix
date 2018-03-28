#!/bin/bash
set -e
########################################

echo "[ARGUMENTS]" "$@"
echo
echo "[provisioning the non-Haskell environment...]"
echo

########################################

nix-shell --show-trace ./shell.system.environment.nix "$@"

########################################
