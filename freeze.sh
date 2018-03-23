#!/bin/bash
set -e
########################################
RELEASE_DIRECTORY=releases
FREEZE_FILE=cabal.project.freeze
########################################
./environment.sh $@ --run 'cabal new-freeze' 

mkdir -p "${RELEASE_DIRECTORY}/"
mv "${FREEZE_FILE}" "${RELEASE_DIRECTORY}/"

cat "${RELEASE_DIRECTORY}/${FREEZE_FILE}"
find "${RELEASE_DIRECTORY}/"
########################################
