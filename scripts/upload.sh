#!/bin/bash
set -e
########################################
cabal check
cabal sdist
########################################
#TODO uploading to hackage
PACKAGE="project2nix"
VERSION="0.0" 
cabal upload dist/"$PACKAGE"-"$VERSION".tar.gz  
########################################
