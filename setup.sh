#!/bin/bash

export SCRIPT_DIR="$(dirname "$0")"

# Load Arguments
setup_database=false
seed_database=false
setup_apps=false
inject_secrets=false

if [ "$1" = "help" ]; then
  echo "Usage: ./setup.sh [-d] [-s]"
  echo "  -d: Setup database"
  echo "  -a: Setup apps"
  echo "  -i: Inject secrets"
  echo "If no arguments are passed, a full setup will be performed"
  exit 0
fi

while getopts dsaif flag
do
    case "${flag}" in
        d) setup_database=true;;
        s) seed_database=true;;
        a) setup_apps=true;;
        i) inject_secrets=true;;
    esac
done

# If no arguments are passed, a full setup will be performed
if [ $setup_database = false ] && [ $seed_database = false ] && [ $setup_apps = false ] && [ $inject_secrets = false ]; then
  echo "No arguments are passed, a full setup will be performed"
  setup_database=true
  seed_database=true
  setup_apps=true
  inject_secrets=true
fi

# Load config
source "${SCRIPT_DIR}/config.sh"

if [ -f ~/.bash_profile ]; then
 source ~/.bash_profile
fi

# Setup database
if [ $setup_database = true ]; then
  echo "Pulling Maria DB"
  docker pull mariadb

  echo "Spinning up a container"
  docker run --detach --name pawntown -e MYSQL_ROOT_PASSWORD=example -p 3307:3306 mariadb:latest

  echo "Sleeping for 10 seconds"
  sleep 10s

  echo "Setup DB"
  mysql --host="127.0.0.1" --port=3307 --user=root --password=example --force -e "CREATE DATABASE pawntown"
fi

# Setup apps
if [ $setup_apps = true ]; then
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
    envInFile=${appArr[3]}
    envOutFile=${appArr[4]}
    fullDir="${APPS_FOLDER}/${name}"

    git clone ${repo} "${fullDir}"
  done
fi

# Inject secrets
if [ $inject_secrets = true ]; then
  source "$SCRIPT_DIR/inject-env.sh"
fi
