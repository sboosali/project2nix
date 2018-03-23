#!/bin/bash
########################################

GHCID_FILE=./ghcid.txt

########################################

echo '...' > "$GHCID_FILE"
# emacsclient "$GHCID_FILE" &

########################################

COMMAND="./environment.sh $@ --run 'cabal new-repl project2nix'"
ghcid -o "$GHCID_FILE" --command "$COMMAND"

########################################
