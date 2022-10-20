APPS_FOLDER="./apps"
APPS=(
  "yarn pawn.town.app git@github.com:mono424/pawn.town.app.git"
  "go pawn.town.live.api git@github.com:mono424/pawn.town.live.api.git"
  "go pawn.town.api git@github.com:mono424/pawn.town.api.git"
)

rm -rf "${APPS_FOLDER}"
mkdir "${APPS_FOLDER}"

for app in "${APPS[@]}"
do
  appArr=($app)
  type=${appArr[0]}
  name=${appArr[1]}
  repo=${appArr[2]}
  fullDir="${APPS_FOLDER}/${name}"

  git clone ${repo} "${fullDir}"

  if [ "$type" = "go" ]; then
    (cd ${fullDir} && go get ./...)
  elif [ "$type" = "yarn" ]; then
    (cd ${fullDir} && yarn)
  fi
done
