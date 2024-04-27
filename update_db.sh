#!/bin/bash
export PATH="/usr/bin:/home/daniel/.nvm/versions/node/v18.19.1/bin"

LOCAL=$(cat head)
REMOTE=$(git ls-remote https://github.com/Kengxxiao/ArknightsGameData_YoStar.git HEAD)
if [[ ! $LOCAL = $REMOTE ]]; then
    echo "$(date) - Start DB update - $REMOTE"
    git ls-remote https://github.com/Kengxxiao/ArknightsGameData_YoStar.git HEAD > head
    cd HellaAPI
    git restore .
    git fetch
    git merge
    npm ci
    sleep 5
    npm run load
    echo "$(date) - DB updated"
    echo "----------"
fi
