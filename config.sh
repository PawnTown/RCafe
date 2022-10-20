#!/bin/bash

export APPS_FOLDER="${SCRIPT_DIR}/apps"
export APPS=(
  "next pawn.town.app git@github.com:mono424/pawn.town.app.git"
  "go pawn.town.live.api git@github.com:mono424/pawn.town.live.api.git"
  "go pawn.town.api git@github.com:mono424/pawn.town.api.git"
)

echo "Config loaded."
