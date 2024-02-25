#!/bin/bash
export PATH=$PATH:/home/daniel8su/.nvm/versions/node/v18.16.1/bin

cd HellaAPI

LOCAL=$(cat head)
REMOTE=$(git ls-remote https://github.com/Kengxxiao/ArknightsGameData_YoStar.git HEAD)
if [[ ! $LOCAL = $REMOTE ]]; then
    git ls-remote https://github.com/Kengxxiao/ArknightsGameData_YoStar.git HEAD > head
    git fetch
    git merge
    npm ci
    sleep 5
    echo "$(date) - Start DB update - $REMOTE"
    node src/utils/loadDb.js
    echo "$(date) - DB updated"
fi