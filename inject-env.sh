#!/bin/bash

export SCRIPT_DIR="$(dirname "$0")"

# Load config
source "${SCRIPT_DIR}/config.sh"

# Clone Env
rm -rf "${ENV_FOLDER}"
git clone ${ENV_REPO} "${ENV_FOLDER}"
(
  cd "${ENV_FOLDER}"
  git checkout ${ENV_BRANCH}
)

#  Inject env files
for app in "${APPS[@]}"
do
  appArr=($app)
  name=${appArr[1]}
  envInFile=${appArr[3]}
  envOutFile=${appArr[4]}
  fullDir="${APPS_FOLDER}/${name}"

  if [ -f "$ENV_FOLDER/$envInFile" ]; then
      echo "${name}: $envInFile will be injected as $envOutFile..."
      cp "$ENV_FOLDER/$envInFile" "${fullDir}/${envOutFile}"
  else 
      echo "WARNING: $ENV_FOLDER/$envInFile does not exist. No env file will be injected. Create it manually later at ${fullDir}/${envOutFile}."
  fi
done

# Cleanup
rm -rf "${ENV_FOLDER}"
