#!/bin/sh
set -e
########################################

OPENER=firfefox
"$OPENER" $@  >/dev/null 2>&1

# TODO
# OPENER=chromium
# "$OPENER" ./dist-newstyle/build/"$ARCHITECTURE/$COMPILER/$PACKAGE-$VERSION"/doc/html/"$PACKAGE"/index.html  >/dev/null 2>&1

########################################

# e.g.
#
# ./open.sh /home/sboo/haskell/project2nix/dist-newstyle/build/x86_64-linux/ghc-8.4.1/project2nix-0.0/doc/html/project2nix/index.html
# 

