#!/bin/bash
set -e
########################################
nix-build --show-trace shell.nix
########################################
# e.g.
# 
# Using install prefix: /nix/store/<hash>-<name>-<version>
#
# Executables installed in:
# /nix/store/<hash>-<name>-<version>/bin
#
# Libraries installed in:
# /nix/store/<hash>-<name>-<version>/lib/<compiler>/<name>-<version>
#
# Dynamic Libraries installed in:
# /nix/store/<hash>-<name>-<version>/lib/<compiler>/<arch>-<os>-<compiler>
#
# Private executables installed in:
# /nix/store/<hash>-<name>-<version>/libexec/<arch>-<os>-<compiler>/<name>-<version>
#
# Data files installed in:
# /nix/store/<hash>-<name>-<version>/share/<arch>-<os>-<compiler>/<name>-<version>
#
# Documentation installed in:
# /nix/store/<hash>-<name>-<version>/share/doc/<arch>-<os>-<compiler>/<name>-<version>
#
# Configuration files installed in:
# /nix/store/<hash>-<name>-<version>/etc
#
########################################
