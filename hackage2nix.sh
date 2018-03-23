#!/bin/bash
set -e
########################################

PACKAGE="${1:?}"

VERSION="$2"

########################################

if [[ -z $2 ]]; then
 VERSION=$(date '+%Y-%m-%d')
 # e.g.
 # $ date '+%Y-%m-%d-%Hh-%Mm-%Ss'
 # 2018-03-23-00h-29m-18s
else
 VERSION="$2" 
 URI="cabal://$NAME-$VERSION"
fi

FILE="$NAME-$VERSION.nix"

########################################
echo
echo '[NAME]'
echo
echo "$NAME"

echo
echo '[VERSION]'
echo
echo "${2:}"

echo
echo "[$FILE]"
echo
cabal2nix "$URI" > "$FILE"
echo
cat "$FILE"

echo 
########################################

# e.g.
# 
# $ ./github2nix.sh https://github.com/haskell/cabal/ Cabal
# $ cat Cabal.json
# 
