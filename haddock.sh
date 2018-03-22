#!/bin/sh
set -e
########################################
cabal new-haddock --haddock-option="--hyperlinked-source"
########################################

ARCHITECTURE="x86_64-linux"
COMPILER="ghc-8.2.2"
OPEN=xdg-open

PACKAGE="project2nix"
VERSION="0.0.0"

"$OPEN" ./dist-newstyle/build/"$ARCHITECTURE/$COMPILER/$PACKAGE-$VERSION"/doc/html/"$PACKAGE"/index.html  >/dev/null 2>&1
########################################
