#!/bin/bash
set -e
########################################

PACKAGE="${1:?}"

VERSION="$2"

########################################

if [[ -z $2 ]]; then
 URI="cabal://$PACKAGE"
 FILE="$PACKAGE.nix"
else
 VERSION="$2" 
 URI="cabal://$PACKAGE-$VERSION"
 FILE="$PACKAGE-$VERSION.nix"
fi

########################################
echo
echo '[PACKAGE]'
echo
echo "$PACKAGE"

echo
echo '[URI]'
echo
echo "${URI}"

echo
echo "[$FILE]"
echo
cabal2nix "$URI" > "$FILE"
echo
cat "$FILE"

echo 
########################################

#USAGE
# e.g.
# 
# $ ./github2nix.sh https://github.com/haskell/cabal/ Cabal
# $ cat Cabal.json
#

#NOTES
 # e.g.
 # $ date '+%Y-%m-%d-%Hh-%Mm-%Ss'
 # 2018-03-23-00h-29m-18s
