#!/bin/bash
export PATH="/usr/bin:/home/daniel/.nvm/versions/node/v18.19.1/bin"

cd HellaAPI

git fetch
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{upstream})
if [[ ! $LOCAL = $REMOTE ]]; then
    echo "$(date) - Start API update - $REMOTE"
    git restore .
    git merge
    npm ci
    sleep 5
    pm2 flush hellaapi
    pm2 restart hellaapi
    echo "$(date) - API updated"
    echo "----------"
fi
