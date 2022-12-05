#!/bin/bash

export APPS_FOLDER="${SCRIPT_DIR}/apps"
export APPS=(
  "next pawn.town.app git@github.com:mono424/pawn.town.app.git .env.app.local .env.local"
  # "go live.pawn.town.api git@github.com:mono424/live.pawn.town.api.git api.local.env env.dev" // not sure if needed
  "go pawn.town.api git@github.com:mono424/pawn.town.api.git .env.api.local .env.dev"
)

echo "Config loaded."
