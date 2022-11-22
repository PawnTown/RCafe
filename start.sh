#!/bin/bash

SCRIPT=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

# Load config
source "$SCRIPT_DIR/config.sh"

# Create commands
processes=()
for app in "${APPS[@]}"
do
  appArr=($app)
  type=${appArr[0]}
  name=${appArr[1]}

  fullDir="${APPS_FOLDER}/${name}"

  if [ "$type" = "go" ]; then
    cd ${fullDir} && go get ./... && go run ${fullDir}/src/cmd &
    processes+=("$!")
  elif [ "$type" = "go:live" ]; then
    cd ${fullDir} && go get ./... && realize start --path="${fullDir}/src/cmd" &
    processes+=("$!")
  elif [ "$type" = "next" ]; then
    cd ${fullDir} && yarn && yarn dev &
    processes+=("$!")
  fi
done

echo "Started processes: ${processes[@]}"
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT
wait "${processes[@]}"
