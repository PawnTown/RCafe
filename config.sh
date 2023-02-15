#!/bin/bash

export APPS_FOLDER="${SCRIPT_DIR}/apps"
export APPS=(
  # <type> <folder> <repo> <src-env-name> <dest-env-name> <tag>
  # PawnTown Core
  "next pawn.town.app git@github.com:PawnTown/pawn.town.app.git .env.app.local .env.local -"
  "go pawn.town.api git@github.com:PawnTown/pawn.town.api.git .env.api.local .env.dev -"
  # PawnTown Live
  "go live.pawn.town.api git@github.com:PawnTown/live.pawn.town.api.git .env.live.api.local .env.dev live"
  # PawnTown Cloud
  "next cloud.pawn.town.app git@github.com:PawnTown/cloud.pawn.town.app.git .env.cloud.app.local .env.local cloud"
  "go cloud.pawn.town.api git@github.com:PawnTown/cloud.pawn.town.api.git .env.cloud.api.local .env.dev cloud"
)

export ENV_FOLDER="${SCRIPT_DIR}/env"
export ENV_REPO="git@github.com:PawnTown/env.git"
export ENV_BRANCH="develop"

echo "Config loaded."
