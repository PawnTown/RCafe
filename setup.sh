#!/bin/bash

export SCRIPT_DIR="$(dirname "$0")"

# Load config
source "${SCRIPT_DIR}/config.sh"

# Reset apps folder
rm -rf "${APPS_FOLDER}"
mkdir "${APPS_FOLDER}"

# Create Database
if [ -f ~/.bash_profile ]; then
 source ~/.bash_profile
fi

echo "Pulling Maria DB"
docker pull mariadb

echo "Spinning up a container"
docker run --detach --name pawntown -e MYSQL_ROOT_PASSWORD=example -p 3307:3306 mariadb:latest

echo "Setup DB"
mysql --host="127.0.0.1" --port=3307 --user=root --password=example --force -e " CREATE DATABASE pawntown"

# Clone apps
for app in "${APPS[@]}"
do
  appArr=($app)
  type=${appArr[0]}
  name=${appArr[1]}
  repo=${appArr[2]}
  envInFile=${appArr[3]}
  envOutFile=${appArr[4]}
  fullDir="${APPS_FOLDER}/${name}"

  git clone ${repo} "${fullDir}"
done

# Inject envs
source "$SCRIPT_DIR/inject-env.sh"
