#!/bin/bash

SCRIPT=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

# Help
if [ "$1" = "help" ]; then
  echo "Usage: ./start.sh [-t tag1,tag2] [-b branch]"
  echo "  -t: Run additional apps with the specified tags"
  echo "  -b: Try to checkout the specified branch on all apps"
  exit 0
fi

# Load Arguments
tags=("-")
branch=""
while getopts t:b: flag
do
    case "${flag}" in
        t) tags+=(${OPTARG//,/ });;
        b) branch=(${OPTARG//,/ })
    esac
done

# Load config
source "$SCRIPT_DIR/config.sh"

# Create commands
processes=()
for app in "${APPS[@]}"
do
  appArr=($app)
  type=${appArr[0]}
  name=${appArr[1]}
  gitUrl=${appArr[2]}
  tag=${appArr[5]}

  if [[ ! " ${tags[*]} " =~ " ${tag} " ]]; then
    echo "⚪️ Skipped $name: Tag(${tag}) was not set"
    continue
  else
    echo "✅ Run $name"
  fi

  if [ "$gitUrl" = "-" ]; then
    echo "No git url set for $name"
  else
    fullDir="${APPS_FOLDER}/${name}"
    (
      cd "$fullDir"
      if [ "$branch" != "" ]; then
        git checkout "$branch"
      fi
      git pull
    )
  fi

  if [ "$type" = "go" ]; then
    cd ${fullDir} && go get ./... && go run ${fullDir}/src/cmd &
    processes+=("$!")
  elif [ "$type" = "go:live" ]; then
    cd ${fullDir} && go get ./... && realize start --path="${fullDir}/src/cmd" &
    processes+=("$!")
  elif [ "$type" = "next" ]; then
    cd ${fullDir} && yarn && yarn dev &
    processes+=("$!")
  elif [ "$type" = "node" ]; then
    cd ${fullDir} && yarn && yarn dev &
    processes+=("$!")
  elif [ "$type" = "livego" ]; then
    docker run --rm -p 1935:1935 -p 7001:7001 -p 7002:7002 -p 8090:8090 gwuhaolin/livego &
    processes+=("$!")
  elif [ "$type" = "livekit" ]; then
    livekit-server --dev --redis-host 127.0.0.1:6379 &
    processes+=("$!")
  elif [ "$type" = "livekit-egress" ]; then
    docker run --rm \
    -e EGRESS_CONFIG_FILE=/out/config.yaml \
    -v ${SCRIPT_DIR}/livekit_egress:/out \
    livekit/egress &
    processes+=("$!")
  fi
done

echo "Started processes: ${processes[@]}"
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT
wait "${processes[@]}"
