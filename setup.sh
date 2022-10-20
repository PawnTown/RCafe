#!/bin/bash

export SCRIPT_DIR="$(dirname "$0")"

# Load config
source "${SCRIPT_DIR}/config.sh"

# Reset apps folder
rm -rf "${APPS_FOLDER}"
mkdir "${APPS_FOLDER}"

# Clone apps
for app in "${APPS[@]}"
do
  appArr=($app)
  type=${appArr[0]}
  name=${appArr[1]}
  repo=${appArr[2]}
  fullDir="${APPS_FOLDER}/${name}"

  git clone ${repo} "${fullDir}"
done
